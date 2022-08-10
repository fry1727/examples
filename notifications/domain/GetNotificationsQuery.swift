//
//  GetViewsQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 5.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct GetNotificationsQuery: Query {
    let first: Int
    let notificationType: NotificationTab
    let excludedIds: [ID]

    struct Response: Codable {
        let data: DataDTO?
        var users: [ProfileDTO] { (data?.viewer?.notificationUsers?.edges ?? []).compactMap { $0.node } }
    }

    struct DataDTO: Codable {
        let viewer: ViewerDTO?
    }

    struct ViewerDTO: Codable {
        let notificationUsers: NotificationUsersDTO?
    }

    struct NotificationUsersDTO: Codable {
        let edges: [NotificationUsersEdgeNode]?
    }

    struct NotificationUsersEdgeNode: Codable {
        let node: ProfileDTO?
    }

    var body: String {
        let fileName = String("\(type(of: self))".split(separator: ".").last!)
        let contentOfFile = Bundle.main.path(forResource: fileName, ofType: "query")!
        let requestString = try! String(contentsOfFile: contentOfFile)
        return String(format: requestString, first, notificationType.type, excludedIds.graphQL)
    }
}
