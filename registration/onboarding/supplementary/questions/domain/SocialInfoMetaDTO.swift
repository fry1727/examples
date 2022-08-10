//
//  QuestionsDTO.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct SocialInfoMeta: Codable {
    let intent: [SocialInfo]
    let relationshipStatus: [SocialInfo]
    let ethnicity: [SocialInfo]
    let kidsAtHome: [SocialInfo]
    let wantsKids: [SocialInfo]
    let education: [SocialInfo]
    let bodyType: [SocialInfo]
}

struct SocialInfo: Codable, Hashable {
    let id: ID
    let value: String
    let icon: String?
}

struct QuestionModel: Hashable {
    let icon: String
    let question: String
    let questionShort: String
    let answers: [SocialInfo]
    let type: QuestionsPageEnum
    let filtersOrder: Int
}

enum QuestionsPageEnum {
    case intence
    case relationShipStatus
    case ethinity
    case kidsAtHome
    case wantKids
    case education
    case bodyType
}
