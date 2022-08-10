//
//  AddFavoritesQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 6.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct AddFavoritesQuery: MutatingQuery {
    var request: Request

    struct Request: Codable {
        let userId: String
    }

    struct DataDTO: Codable {
        let addFavorite: AddFavorite?
    }

    struct AddFavorite: Codable {
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        let data: DataDTO?
        var errorMessage: String? { data?.addFavorite?.errors?.first?.msg }
    }
}
