//
//  MyProfileService.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 11.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//
import Combine
import SwiftUI

final class MyProfileService: ObservableObject {
    static let shared = MyProfileService()

    @AppStorage("myProfileId") var myProfileId: String?
    @AppStorage("clientMutationId") var clientMutationId = ""
    @AppStorage("reactivationReg") var reactivationReg = false
    @AppStorage("smartRepliesTooltipShownCount") var smartRepliesTooltipShownCount = 0
    @AppStorage("matchesTutorialShown") var matchesTutorialShown = false
    @AppStorage("matchesTooTipShown") var matchesTooTipShown = false
    @AppStorage("favedProfileTooltipShown") var favedProfileTooltipShown = false
    @AppStorage("isFinishOnboarding") var isFinishOnboarding = true

    @Published var myProfile: ProfileDTO? {
        didSet {
            if let profile = myProfile {
                myProfileId = profile.id
                AnalyticsService.shared.setUser(profile)
                AnalyticsService.shared.setUserProperties(profile, filters: NearbyService.shared.filters)
            }
        }
    }

    var isVip: Bool {
        myProfile != nil && myProfile?.isVip ?? false
    }

    var hasFreeGifts: Bool {
        return myProfile?.nextGiftDt ?? 0 == 0
    }

    var showSmartRepliesTooltip: Bool {
        smartRepliesTooltipShownCount <= 2
    }

    private var cancellables = Set<AnyCancellable>()

    private init() {}

    func fetchMyProfile() {
        let query = MyProfileQuery()
        HTTPClient.shared.request(query: query)
            .sink(
                receiveCompletion: { result in
                    if case let .failure(error) = result {
                        loge(error)
                    }
                },
                receiveValue: { value in
                    if value.error?.key == "account.deleted" {
                        return self.showAccountDeletedErrorAlert()
                    }
                    self.myProfile = value.profile
                    log()
                }
            )
            .store(in: &cancellables)
    }

    func updateMyProfile(with profile: ProfileDTO) {
        myProfile = profile
    }

    func deletePhoto(photoID: String, completion _: @escaping (Bool) -> Void) {
        HTTPClient.shared.request(query: RemovePhotoQuery(request: .init(photoId: photoID))) { result in
            switch result {
            case let .success(response):
                self.fetchMyProfile()
                if response.errorMessage == nil {
                    log("success")
                }
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    func makePhotoMain(photoID: String, completion _: @escaping (Bool) -> Void) {
        HTTPClient.shared.request(query: MakePhotoMainQuery(request: .init(photoId: photoID))) { result in
            switch result {
            case let .success(response):
                self.fetchMyProfile()
                if response.errorMessage != nil {
                    log("success")
                }
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    func updateProfile(name: String, fullYear: Int, sex: String, lookingFor: String,
                       completion: @escaping (Bool) -> Void)
    {
        let birthDate = getNewBirthday(birthday: myProfile?.birthdate ?? "", newfullYear: fullYear)
        HTTPClient.shared.request(query: UpdateProfileQuery(request:
                .init(firstName: name,
                      birthdate: birthDate,
                      sex: sex,
                      lookingFor: lookingFor)))
        { [weak self] result in
            switch result {
            case let .success(response):
                if response.profile != nil {
                    self?.myProfile = response.profile
                }
                completion(true)
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    func getNewBirthday(birthday: String, newfullYear: Int) -> String {
        let currentDate = Date()
        let newYear = currentDate.year - newfullYear
        let str = birthday
        var monthAndDay = ""
        if let range = str.firstIndex(of: "-") {
            monthAndDay = String(str[range...])
        }
        let newDate = String(newYear) + monthAndDay
        return newDate
    }

    func logOut() {
        HTTPClient.shared.accessToken = ""
        myProfileId = ""
        clientMutationId = ""
        reactivationReg = false
        smartRepliesTooltipShownCount = 0
        matchesTutorialShown = false
        matchesTooTipShown = false
        APNsClient.shared.unregisterFromRemoteNotifications()
        SocketClient.shared.disconnect()
        ChatsService.shared.reset()
        NearbyService.shared.reset()
        MatchesService.shared.reset()
        HomeRouter.shared.reset()
        NotificationsService.shared.reset()
        NotificationsRouter.shared.reset()
        AnalyticsService.shared.setUser(nil)
        favedProfileTooltipShown = false
        let cityId = myProfile?.city?.id ?? ""
        myProfile = nil
        guard let nc = HomePresenter.shared.navigationController as? NavigationController else { return }
        let viewModel = RegistrationViewModel(navController: nc, cityId: cityId)
        let controller = UIHostingController(rootView: RegistrationEmailView(viewModel: viewModel))
        nc.setViewControllers([controller], animated: true)
    }

    private func showAccountDeletedErrorAlert() {
        let alert = AlertInfo(message: L10n.yourAccountDeleted, buttons: [
            AlertInfo.Button(title: L10n.ok, action: {
                self.logOut()
            }),
        ])
        HomePresenter.shared.show(alert: alert)
    }
}
