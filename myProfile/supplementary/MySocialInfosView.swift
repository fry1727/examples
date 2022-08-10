//
//  MySocialInfosView.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 28.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct MySocialInfosView: View {
    let profile: ProfileDTO
    let question: QuestionModel
    let onBackClicked: () -> Void

    @State private var questions: [QuestionModel]
    @State private var socialInfo: UserSocialInfo?

    init(profile: ProfileDTO, question: QuestionModel, onBackClicked: @escaping () -> Void) {
        self.profile = profile
        self.question = question
        self.onBackClicked = onBackClicked
        self._questions = State(initialValue: QuestionsViewModel().questions)
        self._socialInfo = State(initialValue: profile.socialInfo)
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(questions.enumerated()), id: \.element) { index, value in
                            questionSection(for: value)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .id(index)
                        }

                        Spacer()
                            .frame(height: (UIScreen.screenSafeInsets?.bottom ?? 0) + 16)
                    }
                }
                .onAppear {
                    if let questionIndex = questions.firstIndex(of: question) {
                        proxy.scrollTo(questionIndex)
                    }
                }
            }
            .navigation(title: L10n.editProfile, onBackClicked: onBackClicked)
        }
        .navigationViewStyle(.stack)
        .onDisappear {
            if socialInfo != profile.socialInfo {
                saveChanges()
            }
        }
    }

    @ViewBuilder
    private func questionSection(for question: QuestionModel) -> some View {
        VStack(spacing: 0) {
            Text(question.question)
                .setTextStyle(.largeTitle)
                .foregroundColor(Color(.titleTextIcons))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.bottom, 8)
                .padding(.horizontal, 24)

            TaggedView(availableWidth: UIScreen.screenWidth - 64,
                       data: question.answers,
                       spacing: 8,
                       alignment: .leading
            ) { item in
                Button(action: {
                    socialInfo?.setAnswerId(item.id, for: question)
                }) {
                    let isSelected = socialInfo?.getAnswerId(for: question) == item.id
                    Text(item.value)
                        .foregroundColor(isSelected ? .white: Color(.bodyTextIcons))
                        .style(.mediumBody)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(isSelected ? Color(.primary) : Color(.inactiveItem))
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.border), lineWidth: 1)
        )
    }

    private func saveChanges() {
        MyProfileService.shared.myProfile?.socialInfo = socialInfo

        let query = UpdateUserSocialInfo(request: .init(intent: socialInfo?.intent,
                                                        relationshipStatus: socialInfo?.relationshipStatus,
                                                        ethnicity: socialInfo?.ethnicity,
                                                        kidsAtHome: socialInfo?.kidsAtHome,
                                                        wantsKids: socialInfo?.wantsKids,
                                                        education: socialInfo?.education,
                                                        bodyType: socialInfo?.bodyType))
        HTTPClient.shared.request(query: query) { result in
            if case let .failure(error) = result {
                loge(error.localizedDescription)
            }
        }
    }
}
