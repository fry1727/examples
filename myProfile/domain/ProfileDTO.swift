//
//  ProfileDTO.swift
//  MeetvilleTests
//
//  Created by Pavel Pokalnis on 10.03.22.
//  Edited by Yauheni Skiruk on 19.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation
import UIKit

struct ProfileDTO: Codable {
    let id: ID
    var firstName: String?
    var email: String?
    let fullYears: Int?
    var birthdate: String?
    let sex: SexEnum?
    var ownWords: String?
    let online: OnlineStatusEnum?
    let lookingFor: SexEnum?
    var finishedRegistrationDt: Int?
    let isVip: Bool?
    let vipDaysCount: Int?
    let nextGiftDt: Int?
    var autoreply: String?
    var seekingAgeFrom: Int?
    var seekingAgeTo: Int?
    let experiments: [Experiment]?
    let usedTrial: Bool?
    var searchSettings: SearchSettingsDTO?
    var socialInfo: UserSocialInfo?
    var interests: [ID]?

    var idNumeric: String {
        id.base64Decoded()?.replacingOccurrences(of: "user:", with: "") ?? id
    }

    var userProfilePhotos: [UserProfilePhotos] { (photos?.edges ?? [])
        .compactMap { .init(id: $0.node?.id ?? "", photoPreviewUrl: $0.node?.preview?.url,
                            photoBigUrl: $0.node?.big?.url, main: $0.node?.main)
        }
    }

    var reportUserInfo: ReportedUserInfoDTO {
        ReportedUserInfoDTO(id: id, name: firstName ?? "", imageUrl: mainPhotoPreview ?? "")
    }

    var city: CityDTO?
    let photos: PhotosDTO?
    var viewerRelated: ViewerRelatedDTO?
    var counters: CountersDTO?

    var mainPhotoPreview: String? {
        photos?.edges?.first(where: { $0.node?.main == true })?.node?.preview?.url ??
            photos?.edges?.first?.node?.preview?.url
    }

    var mainPhoto: String? {
        photos?.edges?.first(where: { $0.node?.main == true })?.node?.big?.url ??
            photos?.edges?.first?.node?.big?.url
    }

    var fullName: String {
        var name = firstName ?? ""
        if let fullYears = fullYears {
            name.append(contentsOf: ", \(fullYears)")
        }
        return name
    }

    var onlineStatusColor: UIColor {
        switch online {
        case .online:
            return UIColor.getColor(.statusOnline)
        case .recentlyOnline:
            return UIColor.getColor(.statusRecently)
        default:
            return UIColor.clear
        }
    }

    var userWinkedViewer: Bool { viewerRelated?.userWinkedViewer ?? false }
    var userWantsChatViewer: Bool { viewerRelated?.userWantsChatViewer ?? false}
    var winked: Bool { viewerRelated?.winked ?? false }
    var canSendMessage: Bool { viewerRelated?.canSendMessage ?? false }
    var faved: Bool { viewerRelated?.faved ?? false }
    var userLikedViewer: Bool { viewerRelated?.userLikedViewer ?? false }
    var liked: Bool { viewerRelated?.liked ?? false }
    var hasNewLike: Bool { viewerRelated?.notifications?.photoLike?.unreadCount ?? 0 > 0 }
    var hasNewVisit: Bool { viewerRelated?.notifications?.profileVisit?.unreadCount ?? 0 > 0 }
    var hasNewFave: Bool { viewerRelated?.notifications?.favorite?.unreadCount ?? 0 > 0 }
    var userFavedViewer: Bool { viewerRelated?.userFavedViewer ?? false }

    mutating func setWinked() {
        viewerRelated?.winked = true
    }

    mutating func resetNewLike() {
        viewerRelated?.notifications?.photoLike?.unreadCount = 0
    }

    mutating func resetNewVisit() {
        viewerRelated?.notifications?.profileVisit?.unreadCount = 0
    }

    mutating func resetNewFave() {
        viewerRelated?.notifications?.favorite?.unreadCount = 0
    }
}

struct ViewerRelatedDTO: Codable {
    var messages: MessagesDTO?
    var userWinkedViewer: Bool?
    var winked: Bool?
    var canSendMessage: Bool?
    var userWantsChatViewer: Bool?
    var faved: Bool?
    var userLikedViewer: Bool?
    var liked: Bool?
    var userFavedViewer: Bool?
    var notifications: Notifications?

    struct MessagesDTO: Codable {
        var unreadCount: Int?
        var edges: [MessageEdgeNodeDTO]?

        struct MessageEdgeNodeDTO: Codable {
            let node: ChatMessageDTO?
        }
    }

    struct Notifications: Codable {
        var photoLike: UnreadCountDTO?
        var favorite: UnreadCountDTO?
        var profileVisit: UnreadCountDTO?

        struct UnreadCountDTO: Codable {
            var unreadCount: Int?
        }
    }
}

struct CountersDTO: Codable {
    var newMessagesCount: Int
    var newGuestsCount: Int
    var newPhotoLikesCount: Int
    var newFavAddCount: Int
}

enum SexEnum: String, Codable, CaseIterable {
    case male, female

    var name: String {
        switch self {
        case .male: return "male"
        case .female: return "female"
        }
    }
}

enum OnlineStatusEnum: String, Codable {
    case online = "MGraphOnlineStatusEnumOnline"
    case recentlyOnline = "MGraphOnlineStatusEnumRecently"
    case offline = "MGraphOnlineStatusEnumOffline"

    var content: String {
        switch self {
        case .online:
            return ("Online")
        case .recentlyOnline:
            return ("Recently Online")
        case .offline:
            return ("")
        }
    }
}

struct UserProfilePhotos: Codable, Identifiable, Equatable, Hashable {
    var id: ID
    var photoPreviewUrl: String?
    var photoBigUrl: String?
    var main: Bool?
}

struct ReportedUserInfoDTO {
    let id: ID
    let name: String
    let imageUrl: String
}

extension ProfileDTO {
    var chatMessagesUnreadCount: Int { viewerRelated?.messages?.unreadCount ?? 0 }

    mutating func setChatMessagesUnreadCount(_ value: Int) {
        viewerRelated?.messages?.unreadCount = value
    }

    var newMessagesCount: Int { counters?.newMessagesCount ?? 0 }
    var newPhotoLikedCount: Int { counters?.newPhotoLikesCount ?? 0}
    var newViewedCount: Int { counters?.newGuestsCount ?? 0 }
    var newFavedCount: Int { counters?.newFavAddCount ?? 0 }
    var newNotificationsCount: Int { newViewedCount + newPhotoLikedCount + newFavedCount }

    mutating func updateNewMessagesCount(changes: Int) {
        let currentValue = newMessagesCount
        counters?.newMessagesCount = currentValue + changes
    }

    mutating func updateLikedMeCount(changes: Int) {
        let currentValue = newPhotoLikedCount
        counters?.newPhotoLikesCount = currentValue + changes
    }

    mutating func updateViewedMeCount(changes: Int) {
        let currentValue = newViewedCount
        counters?.newGuestsCount = currentValue + changes
    }

    mutating func updateFavedMeCount(changes: Int) {
        let currentValue = newFavedCount
        counters?.newFavAddCount = currentValue + changes
    }

    mutating func resetNewViewedMeCount() {
        counters?.newGuestsCount = 0
    }
}

struct Experiment: Codable {
    var name: String
    var params: String
}

struct SearchSettingsDTO: Codable {
    var ageFrom: Int
    var ageTo: Int
    var city: CityDTO?
    var distance: Int
    var sex: SexEnum?
    var sexAll: Bool?
    var intent: [ID]
    var relationshipStatus: [ID]
    var ethnicity: [ID]
    var kidsAtHome: [ID]
    var wantsKids: [ID]
    var education: [ID]
    var bodyType: [ID]
}

struct UserSocialInfo: Codable, Equatable {
    var intent: ID?
    var relationshipStatus: ID?
    var ethnicity: ID?
    var kidsAtHome: ID?
    var wantsKids: ID?
    var education: ID?
    var bodyType: ID?
}
