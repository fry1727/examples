//
//  AuthExistsQuery.swift
//  Meetville
//
//  Created by Egor Yanukovich on 8.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct AuthExistsQuery: Query {
    let email: String
    let utmSource: String

    struct Response: Codable {
        let data: DataDTO?
        var isCurrentUser: Bool { data?.viewer?.authExists ?? false }
        var isEmailCorrect: Bool { data?.viewer?.validateEmail ?? true }
        var errorMessage: String? { errors?.first?.msg }
        let errors: [ErrorDTO]?
    }

    struct DataDTO: Codable {
        let viewer: ViewerDTO?
    }

    struct ViewerDTO: Codable {
        let authExists: Bool?
        let validateEmail: Bool?
    }

    var body: String {
        let fileName = String("\(type(of: self))".split(separator: ".").last!)
        let contentOfFile = Bundle.main.path(forResource: fileName, ofType: "query")!
        let requestString = try! String(contentsOfFile: contentOfFile)
        return String(format: requestString, email, utmSource, email)
    }
}
