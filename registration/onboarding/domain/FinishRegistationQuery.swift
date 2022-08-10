//
//  FinishRegistationQuery.swift
//  Meetville
//
//  Created by Egor Yanukovich on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct FinishRegistrationQuery: MutatingQuery {
    var request: Request

    struct Request: Codable {
        let clientMutationId: String
    }

    struct Response: Codable {
        private let data: DataDTO?
        var accessToken: String? { data?.finishRegistation?.viewer?.accessToken }
        var clientMutationId: String { data?.finishRegistation?.clientMutationId ?? "" }
        var errorMessage: String? { data?.finishRegistation?.errors?.first?.msg }
        var finishedRegistrationDt: Int? { data?.finishRegistation?.viewer?.profile?.finishedRegistrationDt }
    }

    private struct DataDTO: Codable {
        let finishRegistation: FinishRegistration?
    }

    private struct FinishRegistration: Codable {
        let clientMutationId: String?
        let viewer: ViewerDTO?
        let errors: [ErrorDTO]?
    }

    private struct ViewerDTO: Codable {
        let accessToken: String?
        let profile: ProfileDTO?
    }
}
