//
//  MakePhotoMainQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 31.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct MakePhotoMainQuery: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let photoId: String
    }

    private struct DataDTO: Codable {
        let makePhotoMain: MakePhotoMain?
    }

    private struct MakePhotoMain: Codable {
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.makePhotoMain?.errors?.first?.msg }
    }
}
