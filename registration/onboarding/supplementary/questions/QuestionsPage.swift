//
//  QuestionsPage.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 29.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct QuestionsPage: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    private var questionsViewModel = QuestionsViewModel()
    @State private var subpages: [QuestionView] = []
    @State private var currentSubpage: Int = 0

    var body: some View {
        let subpages = makeSubpages()
        ZStack {
            VStack(spacing: 0) {
                Color(.primary)
                Color.white
                    .clipShape(WaveView())
            }
            .ignoresSafeArea()

            if !subpages.isEmpty {
                PagesView(pages: subpages, currentPage: $currentSubpage)
                    .ignoresSafeArea()
            }
        }
        .onChange(of: currentSubpage) { _ in
            questionsViewModel.currentSubpagePersisted = currentSubpage
        }
        .onAppear {
            if viewModel.restoreOnboardingState {
                currentSubpage = questionsViewModel.currentSubpagePersisted
            }
            self.subpages = subpages
        }
    }

    private func makeSubpages() -> [QuestionView] {
        questionsViewModel.questions.map { question in
            QuestionView(question: question, onSelected: { answer in
                once {
                    questionsViewModel.updateIntentProfile(id: answer, type: question.type)
                    moveNext()
                }
            })
        }
    }

    private func moveNext() {
        defer {
            withAnimation {
                viewModel.progress += 1 / Double(subpages.count)
            }
        }
        guard currentSubpage < subpages.count - 1 else {
            questionsViewModel.currentSubpagePersisted = 0
            return viewModel.openNextPage()
        }
        currentSubpage += 1
    }
}

struct QuestionView: View {
    let question: QuestionModel
    let onSelected: (String) -> Void
    @State private var selectedAnswer: SocialInfo?

    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack(alignment: .leading) {
                    Image(question.icon)
                    Text(question.question)
                        .foregroundColor(.white)
                        .style(.largeTitle)
                        .padding(.top, 28)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 44)

                TaggedView(availableWidth: proxy.size.width - 48,
                           data: question.answers,
                           spacing: 10,
                           alignment: .leading
                ) { item in
                    Button(action: {
                        selectedAnswer = item
                        onSelected(item.id)
                    }) {
                        Text(item.value)
                            .foregroundColor(item == selectedAnswer ? .white: Color(.bodyTextIcons))
                            .style(.mediumBody)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(item == selectedAnswer ? Color(.primary) : Color(.inactiveItem))
                            )
                    }
                }
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            }
        }
    }
}
