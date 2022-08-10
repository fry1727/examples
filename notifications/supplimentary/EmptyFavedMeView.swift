//
//  EmptyFavedMeView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct EmptyFavedMeView: View {
    let homeRouter = HomeRouter.shared

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image("EmptyFaves")
                .resizable()
                .frame(width: 56, height: 56)
            Text(L10n.hereYouLlSeeWhoFavedYou)
                .foregroundColor(.getColor(.bodyTextIcons))
                .setTextStyle(.largeBodyMedium)
            Text(L10n.andForNowFindSomeoneYouWouldLikeToFave)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 55)
                .foregroundColor(.getColor(.subheadText))
                .setTextStyle(.mediumBodyRegular)
            SmallButton(action: {
                openNearby()
            }, text: L10n.findPeople)
                .padding(.top, 12)
        }
    }

    private func openNearby() {
            homeRouter.openTab = .nearby
    }
}

struct EmptyFavedMeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFavedMeView()
    }
}
