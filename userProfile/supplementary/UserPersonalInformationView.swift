//
//  UserProfileToolTip.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 28.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct UserPersonalInformation: View {
    let profile: ProfileDTO
    @State private var answersArray: [SocialInfo] = []
    @State private var questions: [QuestionModel]
    
    init(profile: ProfileDTO) {
        self.profile = profile
        self._questions = State(initialValue: QuestionsViewModel().questions)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(L10n.myPersonalInformation)
                .setTextStyle(.mediumBody)
                .foregroundColor(.getColor(.primary))
                .padding(.top, 8)
            
            TaggedView(availableWidth: UIScreen.screenWidth - 48,
                       data: answersArray,
                       spacing: 8,
                       alignment: .leading
            ) { item in
                makeAnwerCell(id: item.id,
                              icon: item.icon ?? "",
                              value: item.value)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear{
            answersArray = makeAnswers(profile: profile)
        }
    }

    private func makeAnwerCell(id: String, icon: String, value: String) -> some View {
        return Group {
            HStack{
                if id == "city" {
                    Image(icon)
                        .foregroundColor(Color(.bodyTextIcons))
                        .frame(width: 20, height: 20)
                } else {
                    Image(icon)
                        .renderingMode(.template)
                        .foregroundColor(Color(.bodyTextIcons))
                        .scaleEffect(0.35)
                        .frame(width: 20, height: 20)
                }
                Text(value)
                    .style(.mediumBody)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.inactiveItem))
            )
        }
    }
    
    private func makeAnswers(profile: ProfileDTO) -> [SocialInfo] {
        var array: [SocialInfo] = []
        array.append(SocialInfo(id: "city", value: profile.city?.name ?? "", icon: "filter-city"))
        for question in Array(questions.enumerated()) {
            let answer = question.element.answers.first(where: { profile.socialInfo?.getAnswerId(for: question.element) == $0.id })
            if let value = answer?.value {
                array.append(SocialInfo(id: answer?.id ?? "", value: value, icon: question.element.icon))
            }
        }
        return array
    }
}
