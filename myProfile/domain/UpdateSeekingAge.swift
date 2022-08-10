//
//  UpdateSeekingAge.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 28.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct UpdateSeekingAge: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let seekingAgeFrom: Int
        let seekingAgeTo: Int
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
