//
//  UserSocialInfo.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 28.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

extension UserSocialInfo {
    func getAnswerId(for question: QuestionModel) -> ID? {
        switch question.type {
        case .intence:
            return self.intent
        case .relationShipStatus:
            return self.relationshipStatus
        case .ethinity:
            return self.ethnicity
        case .kidsAtHome:
            return self.kidsAtHome
        case .wantKids:
            return self.wantsKids
        case .education:
            return self.education
        case .bodyType:
            return self.bodyType
        }
    }

    mutating func setAnswerId(_ id: ID, for question: QuestionModel) {
        switch question.type {
        case .intence:
            self.intent = id
        case .relationShipStatus:
            self.relationshipStatus = id
        case .ethinity:
            self.ethnicity = id
        case .kidsAtHome:
            self.kidsAtHome = id
        case .wantKids:
            self.wantsKids = id
        case .education:
            self.education = id
        case .bodyType:
            self.bodyType = id
        }
    }
}
