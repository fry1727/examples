//
//  NotificationsTab.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 9.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI
import Combine

enum NotificationTab: Int {
    case likedMe
    case viewedMe
    case favedMe

    var view: AnyView {
        switch self {
        case .likedMe:
            return AnyView(LikedMeView())
        case .viewedMe:
            return AnyView(ViewedMeView())
        case .favedMe:
            return AnyView(FavedMeView())
        }
    }

    var dataSource: AnyPublisher<[ProfileDTO], Never> {
        switch self {
        case .likedMe:
            return NotificationsService.shared
                .$likedMePeople.eraseToAnyPublisher()
        case .viewedMe:
            return NotificationsService.shared
                .$viewedMePeople.eraseToAnyPublisher()
        case .favedMe:
            return NotificationsService.shared
                .$favedMePeople.eraseToAnyPublisher()
        }
    }

    var dataStatus: AnyPublisher<Bool, Never> {
        switch self {
        case .likedMe:
            return NotificationsService.shared
                .$likedMeIsLoading.eraseToAnyPublisher()
        case .viewedMe:
            return NotificationsService.shared
                .$viewedMeIsLoading.eraseToAnyPublisher()
        case .favedMe:
            return NotificationsService.shared
                .$favedMeIsLoading.eraseToAnyPublisher()
        }
    }

    var title: String {
        switch self {
        case .likedMe:
            return L10n.likedMe
        case .viewedMe:
            return L10n.viewedMeV1
        case .favedMe:
            return L10n.favedMe
        }
    }

    var type: String {
        switch self {
        case .likedMe:
            return "photo_like"
        case .viewedMe:
            return "profile_visitor"
        case .favedMe:
            return "fav_add"
        }
    }
}

extension SegmentedTab {
    init(tab: NotificationTab) {
        self.init(title: tab.title)
    }
}
