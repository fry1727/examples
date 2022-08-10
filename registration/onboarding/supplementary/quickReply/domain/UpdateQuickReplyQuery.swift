//
//  UpdateAutoReplyQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 13.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct UpdateQuickReplyQuery: Query, MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let autoreply: String
    }

    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }

    private struct UpdateProfile: Codable {
        let viewer: ViewerDTO?
        let errors: [ErrorDTO]?
    }

    struct ViewerDTO: Codable {
        let profile: ProfileDTO?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var viewer: ViewerDTO? { data?.updateProfile?.viewer }
        var profile: ProfileDTO? { data?.updateProfile?.viewer?.profile }
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}
