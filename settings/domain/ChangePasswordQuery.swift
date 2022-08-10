//
//  ChangePasswordQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct ChangePasswordQuery: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let password: String
        let newPassword: String
        let newPasswordConfirm: String
    }

    private struct DataDTO: Codable {
        let changePassword: ChangePassword?
    }

    private struct ChangePassword: Codable {
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.changePassword?.errors?.first?.msg }
    }
}
