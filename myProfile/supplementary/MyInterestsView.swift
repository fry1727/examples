//
//  MyInterestsView.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 28.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct MyInterestsView: View {
    let myProfile: ProfileDTO
    let onBackClicked: () -> Void
    let onSaveClicked: () -> Void
    
    let interestsViewModel = InterestsViewModel()
    @State private var selectedInterestsOriginally: [Interests] = []
    @State private var selectedInterests: [Interests] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("What are you interested in?")
                    .setTextStyle(.largeTitle)
                    .foregroundColor(Color(.titleTextIcons))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 24)

                ScrollView {
                    Spacer()
                        .frame(height: 16)

                    TaggedView(availableWidth: UIScreen.screenWidth - 32,
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
                            HStack(spacing: 5) {
                                Image(item.id)
                                    .renderingMode(.template)
                                    .foregroundColor(isSelected ? .white: Color(.bodyTextIcons))
                                    .scaleEffect(0.8)

                                Text(item.title)
                                    .foregroundColor(isSelected ? .white: Color(.bodyTextIcons))
                                    .style(.mediumBody)
                            }
                            .padding(.vertical, 9)
                            .padding(.leading, 16)
                            .padding(.trailing, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(isSelected ? Color(.primary) : Color(.primaryLight))
                            )
                        }
                    }
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 75 + (UIScreen.screenSafeInsets?.bottom ?? 0 / 2.5))
                }
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity, alignment: .leading)
                .mask(Color.Gradients.gradientMaskInterests)

                Spacer()
            }
            .overlay(saveButton, alignment: .bottom)
            .navigation(title: L10n.editProfile, onBackClicked: onBackClicked)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            selectedInterests = interestsViewModel.interests
                .filter {
                    myProfile.interests?.contains($0.id) ?? false
                }
            selectedInterestsOriginally = selectedInterests
        }
    }
    
    private func selectInterest(_ item: Interests) {
        if selectedInterests.contains(item) {
            selectedInterests.removeObject(item)
        } else {
            selectedInterests.append(item)
        }
    }
    
    var saveButton: some View {
        let isChanged = selectedInterests.sorted(by: { $0.id < $1.id }) !=
        selectedInterestsOriginally.sorted(by: { $0.id < $1.id })
        return VStack {
            Spacer()
            LargeButton(
                text: selectedInterests.count < 5 ? ("\(selectedInterests.count)/5") : L10n.save,
                style: !isChanged || selectedInterests.count < 5 ? .disabled : .normal,
                action: {
                    if isChanged && selectedInterests.count > 4 {
                        interestsViewModel.updateInterests(interests: selectedInterests)
                        onSaveClicked()
                    }
                }
            )
            .padding(.bottom, 24)
        }
    }
}

