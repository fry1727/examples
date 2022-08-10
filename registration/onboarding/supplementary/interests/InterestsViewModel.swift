//
//  InterestsViewModel.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 20.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

final class InterestsViewModel {
    var interests: [Interests] = []
    
    init() {
        interests = AppConfigService.shared.registrationInterests ?? []
    }
    
    func updateInterests(interests: [Interests]) {
        AnalyticsService.logAmplitudeEvent(.interestsChoose)
        var interestsId: [String] = []
        for interest in interests {
            interestsId.append(interest.id)
        }
        MyProfileService.shared.myProfile?.interests = interestsId
        HTTPClient.shared.request(query: UpdateInterestsQuery(request: .init(interests: interestsId))) { result in
            if case let .failure(error) = result {
                loge(error.localizedDescription)
            }
        }
    }
}
