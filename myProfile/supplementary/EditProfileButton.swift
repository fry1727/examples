//
//  EditProfileButton.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 22.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct EditProfileButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            ZStack {
                Rectangle()
                    .clipShape(Capsule())
                    .foregroundColor(.getColor(.primaryLight))
                    .overlay(Capsule()
                        .strokeBorder(style: StrokeStyle(), antialiased: true)
                        .foregroundColor(Color.clear)
                    )
                HStack(spacing: 0) {
                    Text(L10n.editProfile)
                        .foregroundColor(.getColor(.bodyTextIcons))
                        .setTextStyle(.mediumBody)
                }
            }
            .clipped()
        })
        .frame(width: 140, height: 40)
    }
}

struct EditProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileButton(action: {})
    }
}
