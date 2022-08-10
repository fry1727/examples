//
//  AddFeedbackQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 8.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct AddFeedbackQuery: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let message: String
        let reasonId: String
    }

    private struct DataDTO: Codable {
        let addFeedback: SendFeedback?
    }

    private struct SendFeedback: Codable {
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.addFeedback?.errors?.first?.msg }
    }
}
