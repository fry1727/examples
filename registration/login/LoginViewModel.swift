//
//  LoginViewModel.swift
//  Meetville
//
//  Created by Egor Yanukovich on 13.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    @Published var isLoading = false
    let router: RegistrationRouter

    init(email: String, router: RegistrationRouter) {
        self.email = email
        self.router = router
    }

    func login(_ callback: @escaping () -> Void) {
        isLoading = true
        let query = GenerateAccessTokenQuery(request: .init(email: email, password: password))
        HTTPClient.shared.request(query: query) { [weak self] result in
            self?.isLoading = false
            switch result {
            case let .success(response):
                if let error = response.error {
                    self?.showErrorAlert(error: error)
                } else {
                    HTTPClient.shared.accessToken = response.accessToken ?? ""
                    MyProfileService.shared.clientMutationId = response.clientMutationId
                    callback()
                }
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    func remindPassword() {
        isLoading = true
        let query = RemindPasswordQuery(request: .init(email: email))
        HTTPClient.shared.request(query: query) { [weak self] result in
            self?.isLoading = false
            switch result {
            case let .success(response):
                if let error = response.error {
                    self?.showErrorAlert(error: error)
                } else {
                    self?.showRestorePasswordAlert()
                }
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    private func showErrorAlert(error: ErrorDTO) {
        let alertMessage = RegistrationErrors.getErrorMessage(error: error)
        let actionButtons: [AlertInfo.Button] = [.init(
            title: L10n.ok,
            style: .default
        ) {}]
        let alertInfo = AlertInfo(message: alertMessage, buttons: actionButtons)
        router.show(alert: alertInfo)
    }

    private func showRestorePasswordAlert() {
        let alertMessage = L10n.resetPassword(email)
        let actionButtons: [AlertInfo.Button] = [.init(
            title: L10n.ok,
            style: .default
        ) { [weak self] in
            self?.router.pop()
        }]
        let alertInfo = AlertInfo(message: alertMessage, buttons: actionButtons)
        router.show(alert: alertInfo)
    }
}
