//
//  RegistrationErrors.swift
//  Meetville
//
//  Created by Egor Yanukovich on 21.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct RegistrationErrors {
    private static var registrationServerErrors: [String] {
        return [
            "reg.email",
            "user.self.deleted",
            "account.deleted",
            "user.not.exists",
            "too.much.registrations.attempts",
        ]
    }

    static var commonErrors: [String: String] {
        return [
            "access.token": L10n.theServiceIsNotRespondingPleaseTryLater,
            "password.invalid": L10n.pleaseEnterYourPassword,
        ]
    }

    static func getErrorMessage(error: ErrorDTO) -> String {
        guard let key = error.key else { return "" }
        let message = registrationServerErrors.contains(key) ? error.msg : L10n.somethingWentWrong
        return message
    }
}
