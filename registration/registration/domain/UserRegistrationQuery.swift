//
//  UserRegistrationQuery.swift
//  Meetville
//
//  Created by Egor Yanukovich on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct UserRegistrationQuery: MutatingQuery {
    var request: Request

    struct Request: Codable {
        let email: String
        let firstName: String
        let age: Int
        let sex: SexEnum
        let lookingFor: SexEnum
        let cityId: String
        let utmSource: String?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var accessToken: String? { data?.userRegistration?.viewer?.accessToken }
        var profile: ProfileDTO? { data?.userRegistration?.viewer?.profile }
        var profileCreated: Bool { data?.userRegistration?.profileCreated ?? false }
        var clientMutationId: String { data?.userRegistration?.clientMutationId ?? "" }
        var reactivationReg: Bool { data?.userRegistration?.reactivationReg ?? false }
        var error: ErrorDTO? { data?.userRegistration?.errors?.first }
    }

    private struct DataDTO: Codable {
        let userRegistration: UserRegistration?
    }

    private struct UserRegistration: Codable {
        let clientMutationId: String
        let profileCreated: Bool
        let reactivationReg: Bool
        let viewer: ViewerDTO?
        let errors: [ErrorDTO]?
    }

    private struct ViewerDTO: Codable {
        let accessToken: String?
        let profile: ProfileDTO?
    }
}
