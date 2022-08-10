//
//  EmptyLikedMeView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct EmptyLikedMeView: View {
        let homeRouter = HomeRouter.shared

        var body: some View {
            VStack(alignment: .center, spacing: 4) {
                Image("EmptyLikes")
                    .resizable()
                    .frame(width: 56, height: 56)
                Text(L10n.hereYouLlSeeWhoLikedYou)
                    .foregroundColor(.getColor(.bodyTextIcons))
                    .setTextStyle(.largeBodyMedium)
                Text(L10n.startLikingPeopleFirstAndFindYourBestMatch)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 55)
                    .foregroundColor(.getColor(.subheadText))
                    .setTextStyle(.mediumBodyRegular)
                SmallButton(action: {
                    openMatches()
                }, text: "Find matches")
                    .padding(.top, 12)
            }
        }

        private func openMatches() {
                homeRouter.openTab = .matches
        }
}

struct EmptyLikedMeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyLikedMeView()
    }
}
