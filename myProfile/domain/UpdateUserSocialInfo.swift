//
//  UpdateUserSocialInfo.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 29.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct UpdateUserSocialInfo: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let intent: String?
        let relationshipStatus: String?
        let ethnicity: String?
        let kidsAtHome: String?
        let wantsKids: String?
        let education: String?
        let bodyType: String?
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
