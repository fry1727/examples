//
//  GenerateAccessTokenQuery.swift
//  Meetville
//
//  Created by Egor Yanukovich on 12.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct GenerateAccessTokenQuery: MutatingQuery {
    var request: Request

    struct Request: Codable {
        let email: String
        let password: String
    }

    struct Response: Codable {
        private let data: DataDTO?
        var accessToken: String? { data?.generateAccessToken?.viewer?.accessToken }
        var profile: ProfileDTO? { data?.generateAccessToken?.viewer?.profile }
        var clientMutationId: String { data?.generateAccessToken?.clientMutationId ?? "" }
        var error: ErrorDTO? { data?.generateAccessToken?.errors?.first }
    }

    private struct DataDTO: Codable {
        let generateAccessToken: GenerateAccessToken?
    }

    private struct GenerateAccessToken: Codable {
        let clientMutationId: String?
        let viewer: ViewerDTO?
        let errors: [ErrorDTO]?
    }

    private struct ViewerDTO: Codable {
        let accessToken: String?
        let profile: ProfileDTO?
    }
}
