//
//  AboutMeView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 23.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct AboutMeCell: View {
    let text: String
    var onClicked: () -> Void

    var body: some View {
        VStack {
            Button(action: {
                onClicked()
            }) {
                HStack {
                    Text(L10n.aboutMe)
                        .setTextStyle(.smallBodyMedium)
                        .foregroundColor(.getColor(.primary))
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.getColor(.bodyTextIcons))
                }
                .padding(.top, 16)
                .padding(.bottom, 6)
            }

            VStack {
                if text.isEmpty {
                    Text(L10n.letPeopleKnowHowAmazingYouAre)
                        .setTextStyle(.largeBodyRegular)
                        .foregroundColor(.getColor(.inactiveItemTextIcons))
                } else {
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .setTextStyle(.mediumBodyRegular)
                        .foregroundColor(.getColor(.bodyTextIcons))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeCell(text: "", onClicked: { })
    }
}
