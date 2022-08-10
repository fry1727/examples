//
//  OnboardingPage.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 30.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation
import SwiftUI

enum OnboardingPage: Int, CaseIterable {
    case whatPrefer
    case howOld
    case whatsName
    case addPhotos
    case questions
    case interests
    case quickReply

    var view: AnyView {
        switch self {
        case .whatPrefer:
            return AnyView(RegistrationPreferenceView())
        case .howOld:
            return AnyView(RegistrationAgeView())
        case .whatsName:
            return AnyView(RegistrationNameView())
        case .addPhotos:
            return AnyView(AddPhotosView())
        case .questions:
            return AnyView(QuestionsPage())
        case .interests:
            return AnyView(InterestsPage())
        case .quickReply:
            return AnyView(RegistrationQuickReplyView())
        }
    }

    var progressColors: (primary: Color, secondary: Color?) {
        if self == .questions {
            return (.white, nil)
        }
        return (Color(.primary), Color(.inactiveItem))
    }
}
