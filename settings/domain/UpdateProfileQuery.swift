//
//  UpdateProfileQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 13.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct UpdateProfileQuery: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let firstName: String
        let birthdate: String
        let sex: String
        let lookingFor: String
    }

    struct ViewerDTO: Codable {
        let profile: ProfileDTO?
    }

    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }

    private struct UpdateProfile: Codable {
        let viewer: ViewerDTO?
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var profile: ProfileDTO? { data?.updateProfile?.viewer?.profile }
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}
