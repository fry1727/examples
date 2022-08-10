//
//  SettingsViewModel.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 8.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

final class SettingsViewModel: ObservableObject {
    private let appConfigService = AppConfigService.shared
    private let homePresenter = HomePresenter.shared
    private let myProfileService = MyProfileService.shared

    @Published var feedbackReasons: [FeedbackReasons]
    var termsLink: String
    var privacyLink: String
    var safetyLink: String

    init() {
        feedbackReasons = appConfigService.config?.feedbackReasons ?? []
        termsLink = appConfigService.termsLink
        privacyLink = appConfigService.privacyLink
        safetyLink = appConfigService.safetyLink
    }

    func contactUsMessageSent(text: String, reasonId: String, completion: @escaping (Bool) -> Void) {
        HTTPClient.shared.request(query: AddFeedbackQuery(request: .init(message: text,
                                                                         reasonId: reasonId)))
        { result in
            switch result {
            case let .success(response):
                if response.errorMessage == nil {
                    self.showSupportMessageAlert { _ in
                        completion(true)
                    }
                }
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    func showSupportMessageAlert(completion: @escaping (Bool) -> Void) {
        let alertMessage = L10n.weWillReplyToYourMessageViaEmail
        var actionButtons: [AlertInfo.Button] = []
        actionButtons.append(AlertInfo.Button(title: L10n.ok,
                                              style: .default,
                                              action: {
            completion(true)
        }))
        let alertInfo = AlertInfo(title: "", message: alertMessage, buttons: actionButtons)
        homePresenter.show(alert: alertInfo)
    }

    func showLogOutAlert(completion: @escaping (Bool) -> Void) {
        let alertTitle = L10n.accountSettingsLogoutTitle
        let alertMessage = L10n.accountSettingsLogoutMessage
        var actionButtons: [AlertInfo.Button] = []
        actionButtons.append(AlertInfo.Button(title: L10n.cancel,
                                              style: .default,
                                              action: {
            completion(false)
        }))
        actionButtons.append(AlertInfo.Button(title: L10n.logOut,
                                              style: .default,
                                              action: {
            completion(true)
        }))
        let alertInfo = AlertInfo(title: alertTitle, message: alertMessage, buttons: actionButtons)
        homePresenter.show(alert: alertInfo)
    }

    func showsomethingWentWrongAlert() {
        let alertTitle = ""
        let alertMessage = "Please, check if the fields are correct and try again"
        var actionButtons: [AlertInfo.Button] = []
        actionButtons.append(AlertInfo.Button(title: L10n.ok,
                                              style: .default,
                                              action: {}))
        let alertInfo = AlertInfo(title: alertTitle, message: alertMessage, buttons: actionButtons)
        homePresenter.show(alert: alertInfo)
    }

    func logOut() {
        MyProfileService.shared.logOut()
    }

    func deleteUser(reason: String, callback: @escaping () -> Void) {
        HTTPClient.shared.request(query: RemoveUserMutationQuery(request: .init(reason: reason))) { result in
            switch result {
            case let .success(response):
                if response.errorMessage == nil {
                    callback()
                } else {
                    self.showsomethingWentWrongAlert()
                }
            case .failure:
                self.showsomethingWentWrongAlert()
            }
        }
    }

    func changeEmail(email: String, password: String, completion: @escaping (Bool) -> Void) {
        HTTPClient.shared.request(query: ChangeEmailMutationQuery(request: .init(email: email,
                                                                                 password: password)))
        { result in
            switch result {
            case let .success(response):
                if response.errorMessage == nil {
                    self.myProfileService.myProfile?.email = email
                    completion(true)
                } else {
                    self.showsomethingWentWrongAlert()
                }
            case .failure:
                self.showsomethingWentWrongAlert()
            }
        }
    }

    func changePassword(password: String, newPassword: String,
                        confirmedNewPassword: String, completion: @escaping (Bool) -> Void)
    {
        HTTPClient.shared.request(query: ChangePasswordQuery(request: .init(password: password,
                                                                            newPassword: newPassword,
                                                                            newPasswordConfirm: confirmedNewPassword)))
        { result in
            switch result {
            case let .success(response):
                if response.errorMessage == nil {
                    completion(true)
                } else {
                    self.showsomethingWentWrongAlert()
                }
            case .failure:
                self.showsomethingWentWrongAlert()
            }
        }
    }
}
