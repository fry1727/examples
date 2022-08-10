//
//  RegistrationViewModel.swift
//  Meetville
//
//  Created by Egor Yanukovich on 9.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Combine
import SwiftUI

final class RegistrationViewModel: ObservableObject {
    @AppStorage("currentPagePersisted") var currentPagePersisted = 0
    @AppStorage("progressPersisted") var progressPersisted = 0.0
    @AppStorage("restoreOnboardingState") var restoreOnboardingState = false

    @Published var email = ""
    @Published var isCurrentUser = false
    @Published var age = 0
    @Published var name = ""
    @Published var isSubscriptionPurchased = false
    var selectedPreference: RegestrationPreference = .manSeekingWoman
    let cityId: String

    let router: RegistrationRouter
    let subscriptionsService = SubscriptionsService.shared
    var subscriptionsPresenter = SubscriptionsPresenter.shared
    var myProfile = MyProfileService.shared

    @Published var isLoading = false
    private var cancellables: [AnyCancellable] = []

    @Published var emailError = ""
    @Published var isEmailValid: Bool = false
    
    @Published var pages: [OnboardingPage] = [
        .whatPrefer,
        .howOld,
        .whatsName,
        .addPhotos,
        .questions,
        .interests,
        .quickReply,
    ]

    @Published var currentPage: Int = 0 {
        didSet {
            currentPagePersisted = currentPage
        }
    }

    @Published var progress: Double = 0 {
        didSet {
            progressPersisted = progress
        }
    }
    
    var currentOnbaordingPage: OnboardingPage {
        pages[currentPage]
    }

    init(navController: UINavigationController? = nil, cityId: String) {
        router = RegistrationRouter(navController: navController)
        self.cityId = cityId

        if restoreOnboardingState {
            currentPage = currentPagePersisted
            progress = progressPersisted
        }
    }
    
    func openNextPage() {
        guard currentPage < pages.count - 1 else {
            finishOnboarding()
            return showPaywallOnRegistration()
        }
        let indexBeforeQuickReply = pages.index(before: OnboardingPage.quickReply.rawValue)
        if currentPage == indexBeforeQuickReply && myProfile.myProfile?.sex != .female && myProfile.myProfile?.lookingFor != .male {
            finishOnboarding()
            return showPaywallOnRegistration()
        }
        withAnimation {
            currentPage += 1
        }
    }
    
    func enterEmailButtonPressed(email: String, _ callback: @escaping () -> Void) {
        guard isEmailValid else { return }
        checkEmail(email) { isCurrentUser in
            if isCurrentUser {
                self.emailError = L10n.emailBelongsToExistingAccount
            } else {
                self.isCurrentUser = isCurrentUser
                callback()
            }
        }
    }
    
    private func checkEmail(_ email: String, _ callback: @escaping (Bool) -> Void) {
        let query = AuthExistsQuery(email: email,
                                    utmSource: AnalyticsService.shared.getMediaSourse())
        isLoading = true
        
        HTTPClient.shared.request(query: query).sink { result in
            self.isLoading = false
            if case let .failure(error) = result {
                loge(error)
            }
        } receiveValue: { result in
            if let error = result.errors?.first {
                self.emailError = RegistrationErrors.getErrorMessage(error: error)
            } else {
                callback(result.isCurrentUser)
            }
        }.store(in: &cancellables)
    }

    func loginUser() {
        MyProfileService.shared.fetchMyProfile()
        BlockReportService.shared.refreshBlockedUsers()
        APNsClient.shared.registerForRemoteNotifications()
        SocketClient.shared.reconnect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.router.navigationController?.setViewControllers(
                [HomeViewController()], animated: false
            )
        }
    }
    
    func finishOnboarding() {
        currentPage = 0
        progress = 0.0
        currentPagePersisted = 0
        progressPersisted = 0.0
        restoreOnboardingState = false
        sendFinishRegistration()
    }
    
    func showFinishRegistrationPage() {
        router.push(view: FinishRegistrationView().environmentObject(self))
    }
    
    func registerUser(_ callback: @escaping () -> Void) {
        isLoading = true
        myProfile.isFinishOnboarding = false
        let query = UserRegistrationQuery(
            request: .init(
                email: email,
                firstName: name,
                age: age,
                sex: selectedPreference.sex,
                lookingFor: selectedPreference.lookingFor,
                cityId: cityId,
                utmSource: AnalyticsService.shared.getMediaSourse()
            ))
        
        HTTPClient.shared.request(query: query).sink { result in
            self.isLoading = false
            if case let .failure(error) = result {
                loge(error)
            }
        } receiveValue: { [weak self] response in
            if response.profileCreated {
                HTTPClient.shared.accessToken = response.accessToken ?? ""
                MyProfileService.shared.clientMutationId = response.clientMutationId
                MyProfileService.shared.reactivationReg = response.reactivationReg
                MyProfileService.shared.myProfile = response.profile
                AnalyticsService.logAmplitudeEvent(.profileCreate)
                AnalyticsService.logAppsFlyerEvent(.profileCreate(userID: response.profile?.idNumeric ?? ""))
                self?.sendAddInstallationInfo()
                callback()
            } else {
                self?.showAlert(error: response.error)
            }
        }.store(in: &cancellables)
    }

    func sendAddInstallationInfo() {
        let appsflyerInfo = AnalyticsService.shared.appsflyerData.toJSONStringUsingSerialization()
        let info = InstallationInfo().value
        HTTPClient.shared.request(query: AddInstallationInfoQuery(request: .init(appsflyerInfo: appsflyerInfo, info: info))) { result in
            if case let .failure(error) = result {
                loge(error.localizedDescription)
            }
        }
    }

    private func sendFinishRegistration() {
        let query = FinishRegistrationQuery(request: .init(clientMutationId: myProfile.clientMutationId))
        HTTPClient.shared.request(query: query) { result in
            switch result {
            case let .success(response):
                if let errorMessage = response.errorMessage {
                    return loge(errorMessage)
                }
                self.myProfile.isFinishOnboarding = true
                self.logCompleteRegistration()
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    private func logCompleteRegistration() {
        AnalyticsService.logAppsFlyerEvent(.completeRegistration(userID: myProfile.myProfile?.idNumeric ?? ""))
        AnalyticsService.logAmplitudeEvent(.registerComplete)
    }

    private func showAlert(error: ErrorDTO?) {
        var alertMessage = ""
        if let error = error {
            alertMessage = RegistrationErrors.getErrorMessage(error: error)
        } else {
            alertMessage = L10n.somethingWentWrong
        }
        
        let actionButtons: [AlertInfo.Button] = [
            .init(title: L10n.ok,
                  style: .default) {},
        ]
        let alertInfo = AlertInfo(message: alertMessage, buttons: actionButtons)
        router.show(alert: alertInfo)
    }
}

// MARK: - Subscriptions on registration

extension RegistrationViewModel {
    func showPaywallOnRegistration() {
        let view = PaywallView(theme: .dark,
                               reason: .step,
                               onCloseClicked: onCloseClicked,
                               onRestoreClicked: { self.onRestoreClickedOnRegistration() },
                               onPurchaseClicked: { self.onPurchaseClickedOnRegistration($0) })
        router.push(view: view)
    }
    
    private func onCloseClicked() {
        self.showFinishRegistrationPage()
        AnalyticsService.logAmplitudeEvent(.stepSubscribe(result: .close))
    }
    
    private func onRestoreClickedOnRegistration() {
        self.subscriptionsPresenter.isLoading = true
        subscriptionsService.restorePurchases { [weak self] in
            guard let self = self else { return }
            self.subscriptionsPresenter.isLoading = false
            if case let .failure(error) = $0 {
                loge(error)
                self.showRestoreError(error)
            } else {
                self.isSubscriptionPurchased = true
                self.showFinishRegistrationPage()
            }
        }
    }
    
    private func onPurchaseClickedOnRegistration(_ subscription: ProductSubscription) {
        self.subscriptionsPresenter.isLoading = true
        subscriptionsService.purchase(subscription: subscription) { [weak self] in
            guard let self = self else { return }
            self.subscriptionsPresenter.isLoading = false
            if case let .failure(error) = $0 {
                guard error != .canceled else { return }
                loge(error)
                self.showPurchaseError(error)
            } else {
                self.isSubscriptionPurchased = true
                self.showFinishRegistrationPage()
            }
        }
    }
    
    private func showPurchaseError(_ error: SubscriptionError) {
        var errorMessage = L10n.somethingWentWrong
        if error.isOurSideError {
            errorMessage += " \("Please try to restore purchases or contact us.")"
        }
        let alertInfo = AlertInfo(message: errorMessage,
                                  buttons: [AlertInfo.Button(title: L10n.ok, action: {})])
        router.show(alert: alertInfo)
    }
    
    private func showRestoreError(_ error: SubscriptionError) {
        let alertInfo = AlertInfo(title: "Sorry, no subscription found",
                                  message: "If you subscribed with a different Apple ID, sign in with your Meetville account to access subscription there. Or contact us to get help.",
                                  buttons: [AlertInfo.Button(title: L10n.ok, action: {})])
        router.show(alert: alertInfo)
    }
}


// MARK: - Preferences Enum

enum RegestrationPreference: CaseIterable {
    case manSeekingWoman
    case womanSeekingMan
    case manSeekingMan
    case womanSeekingWoman
    
    var description: String {
        switch self {
        case .manSeekingWoman:
            return L10n.imAManSeekingAWoman
        case .womanSeekingMan:
            return L10n.iamAWomanSeekingAMan
        case .manSeekingMan:
            return L10n.imAManSeekingAMan
        case .womanSeekingWoman:
            return L10n.iamAWomanSeekingAWoman
        }
    }
    
    var sex: SexEnum {
        switch self {
        case .manSeekingWoman, .manSeekingMan:
            return .male
        case .womanSeekingMan, .womanSeekingWoman:
            return .female
        }
    }
    
    var lookingFor: SexEnum {
        switch self {
        case .manSeekingWoman, .womanSeekingWoman:
            return .female
        case .womanSeekingMan, .manSeekingMan:
            return .male
        }
    }
}
