//
//  InterestsPage.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 29.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct InterestsPage: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    var interestsViewModel = InterestsViewModel()
    @State private var selectedInterests: [Interests] = []
    
    var body: some View {
            VStack(spacing: 0) {
                Text("What are you interested in?")
                    .foregroundColor(Color(.titleTextIcons))
                    .style(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("It will help us find people with similar interests. Choose at least 5. ")
                    .foregroundColor(Color(.subheadText))
                    .style(.mediumBodyRegular)
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    Spacer()
                        .frame(height: 16)

                    TaggedView(availableWidth: UIScreen.screenWidth - 48,
                               data: interestsViewModel.interests,
                               spacing: 8,
                               alignment: .leading
                    ) { item in
                        Button(action: {
                            selectInterest(item)
                        }) {
                            let isSelected = selectedInterests.contains(where: {
                                $0.title == item.title
                            })
                            HStack(spacing: 9) {
                                Image(item.id)
                                    .renderingMode(.template)
                                    .foregroundColor(isSelected ? .white: Color(.bodyTextIcons))
                                
                                Text(item.title)
                                    .foregroundColor(isSelected ? .white: Color(.bodyTextIcons))
                                    .style(.mediumBody)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(isSelected ? Color(.primary) : Color(.inactiveItem))
                            )
                        }
                    }
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 75)
                }
                .mask(Color.Gradients.gradientMaskInterests)
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
                
                Spacer()
            }
            .padding(.top, 100)
            .padding(.horizontal, 24)
            .overlay(button, alignment: .bottom)
    }
    
    private func selectInterest(_ item: Interests) {
        var progressChange = 0.0
        if selectedInterests.contains(item) {
            selectedInterests.removeObject(item)
            progressChange = -1/5.0
        } else {
            selectedInterests.append(item)
            progressChange = 1/5.0
        }
        withAnimation {
            viewModel.progress += progressChange
        }
    }
    
    var button: some View {
        VStack {
            Spacer()
            LargeButton(
                text: selectedInterests.count < 5 ? ("\(selectedInterests.count)/5") : L10n.continue,
                style: selectedInterests.count < 5 ? .disabled : .normal,
                rightIcon: selectedInterests.count > 4 ? "arrow_forward" : "",
                showLoader: viewModel.isLoading,
                action: {
                    if selectedInterests.count > 4 {
                        once {
                            viewModel.openNextPage()
                            interestsViewModel.updateInterests(interests: selectedInterests)
                        }
                    }
                }
            )
            .padding(.bottom, 24)
        }
    }
    
    func onNextClicked() {
        once {
            viewModel.openNextPage()
            withAnimation {
                viewModel.progress += 1
            }
        }
    }
}
