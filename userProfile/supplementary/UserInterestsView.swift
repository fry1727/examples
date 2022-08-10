//
//  MyInterestsView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 29.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct UserInterestsView: View {
    let profile: ProfileDTO
    let interestsViewModel = InterestsViewModel()
    let myProfile = MyProfileService.shared.myProfile
    @State private var interests: [Interests] = []
    
    init(profile: ProfileDTO) {
        self.profile = profile
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if !interests.isEmpty {
                Text("My Interests")
                    .setTextStyle(.mediumBody)
                    .foregroundColor(.getColor(.primary))
                    .padding(.top, 8)
                TaggedView(availableWidth: UIScreen.screenWidth - 48,
                           data: interests,
                           spacing: 8,
                           alignment: .leading
                )
                { item in
                    Group {
                        let isSelected = myProfile?.interests?.contains(where: { $0 == item.id })
                        HStack(spacing: 5) {
                            Image(item.id)
                                .renderingMode(.template)
                                .foregroundColor(isSelected ?? false ? .white: Color(.bodyTextIcons))
                                .scaleEffect(0.8)

                            Text(item.title)
                                .foregroundColor(isSelected ?? false ? .white: Color(.bodyTextIcons))
                                .style(.mediumBody)
                        }
                        .padding(.vertical, 9)
                        .padding(.leading, 16)
                        .padding(.trailing, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(isSelected ?? false ? Color(.primary) : Color(.inactiveItem))
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .onAppear {
            interests = interestsViewModel.interests
                .filter {
                    profile.interests?.contains($0.id) ?? false
                }
        }
    }
}

