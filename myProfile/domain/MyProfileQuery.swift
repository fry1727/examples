//
//  MyProfileQuery.swift
//  MeetvilleTests
//
//  Created by Pavel Pokalnis on 10.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct MyProfileQuery: Query {
    struct Response: Codable {
        private let data: DataDTO?
        private let errors: [ErrorDTO]?
        var profile: ProfileDTO? { data?.viewer?.profile }
        var error: ErrorDTO? { errors?.first }
    }

    struct DataDTO: Codable {
        let viewer: ViewerDTO?
    }

    struct ViewerDTO: Codable {
        let accessToken: String?
        let profile: ProfileDTO?
    }
}
