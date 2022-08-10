//
//  QuestionsViewModel.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

final class QuestionsViewModel {
    @AppStorage("currentSubpagePersisted") var currentSubpagePersisted = 0
    var questions: [QuestionModel] = []
    var subpages: [QuestionView] = []
    let registrationQuestions = AppConfigService.shared.registrationQuestions
    @State private var currentSubpage: Int = 0

    init() {
        questions = makeQuestions()
    }

    func makeQuestions() -> [QuestionModel] {
        if let registrationQuestions = registrationQuestions {
            return [.init(icon: "onboarding-eye",
                          question: "What are you looking for?",
                          questionShort: "Looking for",
                          answers: registrationQuestions.intent,
                          type: .intence,
                          filtersOrder: 0),
                    .init(icon: "onboarding-heart",
                          question: "What is your relationship status?",
                          questionShort: "Relationship status",
                          answers: registrationQuestions.relationshipStatus,
                          type: .relationShipStatus,
                          filtersOrder: 1),
                    .init(icon: "onboarding-person",
                          question: "What’s your ethnicity?",
                          questionShort: "Ethnicity",
                          answers: registrationQuestions.ethnicity,
                          type: .ethinity,
                          filtersOrder: 2),
                    .init(icon: "onboarding-family",
                          question: "Do you have kids?",
                          questionShort: "Have kids",
                          answers: registrationQuestions.kidsAtHome,
                          type: .kidsAtHome,
                          filtersOrder: 5),
                    .init(icon: "onboarding-children",
                          question: "Do you want kids?",
                          questionShort: "Want kids",
                          answers: registrationQuestions.wantsKids,
                          type: .wantKids,
                          filtersOrder: 6),
                    .init(icon: "onboarding-education",
                          question: "What level of education you have?",
                          questionShort: "Education",
                          answers: registrationQuestions.education,
                          type: .education,
                          filtersOrder: 4),
                    .init(icon: "onboarding-body-shape",
                          question: "What’s your body type?",
                          questionShort: "Body type",
                          answers: registrationQuestions.bodyType,
                          type: .bodyType,
                          filtersOrder: 3)
            ]
        } else {
            return []
        }
    }

    func updateIntentProfile(id: String, type: QuestionsPageEnum) {
        switch type {
        case .intence:
            AnalyticsService.logAmplitudeEvent(.stepLookingFor)
            HTTPClient.shared.request(query: UpdateIntentQuery(request: .init(intent: id))) { result in
                if case let .failure(error) = result {
                    loge(error.localizedDescription)
                }
            }
        case .relationShipStatus:
            AnalyticsService.logAmplitudeEvent(.stepMarriage)
            HTTPClient.shared.request(query: UpdateRelationshipStatusQuery(request: .init(relationshipStatus: id)))
            { result in
                if case let .failure(error) = result {
                    loge(error.localizedDescription)
                }
            }
        case .ethinity:
            AnalyticsService.logAmplitudeEvent(.stepEthnicity)
            HTTPClient.shared.request(query: UpdateEthnicityQuery(request: .init(ethnicity: id))) { result in
                if case let .failure(error) = result {
                    loge(error.localizedDescription)
                }
            }
        case .kidsAtHome:
            AnalyticsService.logAmplitudeEvent(.stepKids)
            HTTPClient.shared.request(query: UpdateKidsAtHomeQuery(request: .init(kidsAtHome: id))) { result in
                if case let .failure(error) = result {
                    loge(error.localizedDescription)
                }
            }
        case .wantKids:
            AnalyticsService.logAmplitudeEvent(.stepWantKids)
            HTTPClient.shared.request(query: UpdateWantsKidsQuery(request: .init(wantsKids: id))) { result in
                if case let .failure(error) = result {
                    loge(error.localizedDescription)
                }
            }
        case .education:
            AnalyticsService.logAmplitudeEvent(.stepEducation)
            HTTPClient.shared.request(query: UpdateEducationQuery(request: .init(education: id))) { result in
                if case let .failure(error) = result {
                    loge(error.localizedDescription)
                }
            }
        case .bodyType:
            AnalyticsService.logAmplitudeEvent(.stepBody)
            HTTPClient.shared.request(query: UpdateBodyTypeQuery(request: .init(bodyType: id))) { result in
                if case let .failure(error) = result {
                    loge(error.localizedDescription)
                }
            }
        }

    }
}


