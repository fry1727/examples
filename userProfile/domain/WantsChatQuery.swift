//
//  WantsChatQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 20.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct WantsChatQuery: MutatingQuery {
    var request: Request
    
    struct Request: Codable {
        let userId: String
    }
    
    struct DataDTO: Codable {
        let delayedChat: DelayedChat?
    }
    
    struct DelayedChat: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        let data: DataDTO?
        var errorMessage: String? { data?.delayedChat?.errors?.first?.msg }
    }
}
