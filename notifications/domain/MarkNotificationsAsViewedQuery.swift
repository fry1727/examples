//
//  MarkNotificationsAsViewedQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 10.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

struct MarkNotificationsAsViewedQuery: MutatingQuery {
    var request: Request

    struct Request: Codable {
        let types: [String]
        let userIds: [ID]
    }

    struct Response: Codable {
        let data: DataDTO?
        var errorMessage: String? { data?.markNotificationAsViewed?.errors?.first?.msg }
    }

    struct DataDTO: Codable {
        let markNotificationAsViewed: MarkNotificationAsViewed?
    }

    struct MarkNotificationAsViewed: Codable {
        let errors: [ErrorDTO]?
    }
}
