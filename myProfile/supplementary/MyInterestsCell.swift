//
//  MyInterestsView.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 28.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct MyInterestsCell: View {
    let myProfile: ProfileDTO
    let onClicked: () -> Void
    
    let interestsViewModel = InterestsViewModel()
    @State private var selectedInterests: [Interests] = []
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                onClicked()
            }) {
                HStack(spacing: 0) {
                    Text("My Interests")
                        .setTextStyle(.smallBodyMedium)
                        .foregroundColor(.getColor(.primary))
                        .padding(.vertical, 16)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.getColor(.bodyTextIcons))
                }
            }
            
            if selectedInterests.isEmpty {
                Text(L10n.letPeopleKnowHowAmazingYouAre)
                    .setTextStyle(.largeBodyRegular)
                    .foregroundColor(.getColor(.inactiveItemTextIcons))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                TaggedView(availableWidth: UIScreen.screenWidth - 48,
                           data: selectedInterests,
                           spacing: 8,
                           alignment: .leading
                ) { item in
                    Group {
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
                                .fill(isSelected ? Color(.primary) : Color(.inactiveItem))
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .id(selectedInterests.count)
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            selectedInterests = interestsViewModel.interests
                .filter {
                    myProfile.interests?.contains($0.id) ?? false
                }
        }
    }
}
