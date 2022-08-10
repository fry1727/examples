//
//  ChangeEmailMutationQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct ChangeEmailMutationQuery: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let email: String
        let password: String
    }

    private struct DataDTO: Codable {
        let changeEmail: ChangeEmail?
    }

    private struct ChangeEmail: Codable {
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.changeEmail?.errors?.first?.msg }
    }
}
