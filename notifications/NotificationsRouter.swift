//
//  NotificationsRouter.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 9.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Combine
import SwiftUI

final class NotificationsRouter: ObservableObject {
    static let shared = NotificationsRouter()

    @Published var openTabIndex = NotificationTab.likedMe.rawValue

    private init() {}

    func open(tab: NotificationTab) {
        openTabIndex = tab.rawValue
    }

    func reset() {
        openTabIndex = NotificationTab.likedMe.rawValue
    }
}
