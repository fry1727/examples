//
//  UpdateInterestsQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 21.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct UpdateInterestsQuery: Query, MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let interests: [String]?
    }

    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }

    private struct UpdateProfile: Codable {
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}
