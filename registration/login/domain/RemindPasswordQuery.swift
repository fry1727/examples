//
//  RemindPasswordMutation.swift
//  Meetville
//
//  Created by Egor Yanukovich on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct RemindPasswordQuery: MutatingQuery {
    var request: Request

    struct Request: Codable {
        let email: String
    }

    struct Response: Codable {
        private let data: DataDTO?
        var error: ErrorDTO? { data?.remindPassword?.errors?.first }
        var message: String { data?.remindPassword?.errors?.first?.msg ?? "" }
    }

    private struct DataDTO: Codable {
        let remindPassword: RemindPassword?
    }

    private struct RemindPassword: Codable {
        let errors: [ErrorDTO]?
    }
}
