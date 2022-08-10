//
//  RemoveUserMutationQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct RemoveUserMutationQuery: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let reason: String
    }

    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.removeUser?.errors?.first?.msg }
    }

    private struct DataDTO: Codable {
        let removeUser: RemoveUser?
    }

    private struct RemoveUser: Codable {
        let errors: [ErrorDTO]?
    }
}
