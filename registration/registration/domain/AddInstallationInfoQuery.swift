//
//  AddInstallationInfoQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 12.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct AddInstallationInfoQuery: MutatingQuery {
    var request: RequestObject

    struct RequestObject: Codable {
        let appsflyerInfo: String
        let info: String
    }

    private struct DataDTO: Codable {
        let addInstallationInfo: AddInstallationInfo?
    }

    private struct AddInstallationInfo: Codable {
        let errors: [ErrorDTO]?
    }

    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.addInstallationInfo?.errors?.first?.msg }
    }
}

