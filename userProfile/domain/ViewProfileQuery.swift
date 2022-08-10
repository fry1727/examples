//
//  ViewProfileQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 20.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct ViewProfileQuery: MutatingQuery {
    var request: Request
    
    struct Request: Codable {
        let userId: String
    }
    
    struct DataDTO: Codable {
        let viewProfile: ViewProfile?
    }
    
    struct ViewProfile: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        let data: DataDTO?
        var errorMessage: String? { data?.viewProfile?.errors?.first?.msg }
    }
}
