//
//  ProfileDTO+Settings.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

extension ProfileDTO {
    var sexAdnPreferences: RegestrationPreference {
        if sex == .male, lookingFor == .female {
            return .manSeekingWoman
        } else if sex == .male, lookingFor == .male {
            return .manSeekingMan
        } else if sex == .female, lookingFor == .male {
            return .womanSeekingMan
        } else {
            return .womanSeekingWoman
        }
    }
}
