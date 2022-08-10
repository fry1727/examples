//
//  RemovePhotoQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 31.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct RemovePhotoQuery: Query, MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let photoId: String
    }

    private struct DataDTO: Codable {
        let removePhoto: RemovePhoto?
    }

    private struct RemovePhoto: Codable {
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.removePhoto?.errors?.first?.msg }
    }
}
