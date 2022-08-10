//
//  RegistrationEmailViewModel.swift
//  Meetville
//
//  Created by Egor Yanukovich on 10.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Combine
import SwiftUI

final class RegistrationEmailViewModel: ObservableObject {
    @Published var isCurrentUser = false
    @Published var isEmailCorrect = false
    @Published var emailError = ""
    @Published var isLoading = false
    @Published var isEmailValid: Bool = false
    private var cancellables: [AnyCancellable] = []

    func buttonAction(email: String, _ callback: @escaping () -> Void) {
        guard isEmailValid else { return }
            checkEmail(email) { isCurrentUser, isEmailCorrect in
                if isCurrentUser {
                    self.emailError = L10n.emailBelongsToExistingAccount
                } else if !isEmailCorrect {
                    self.emailError = "Your email seems incorrect"
                } else {
                    self.isCurrentUser = isCurrentUser
                    callback()
                }
            }
    }

    private func checkEmail(_ email: String,
                            _ callback: @escaping (_ isCurrentUser: Bool, _ isEmailCorrect : Bool) -> Void) {
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
                callback(result.isCurrentUser, result.isEmailCorrect)
            }
        }.store(in: &cancellables)
    }
}
