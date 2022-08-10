//
//  ViewsEmpty.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 4.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct EmptyViewedMeView: View {
    let homeRouter = HomeRouter.shared

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image("EmptyViews")
                .resizable()
                .frame(width: 56, height: 56)
            Text(L10n.hereYouLlSeeYourVisitors )
                .foregroundColor(.getColor(.bodyTextIcons))
                .setTextStyle(.largeBodyMedium)
            Text(L10n.inTheMeantimeCheckOtherPeopleSProfiles)
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

struct ViewsEmptyList_Previews: PreviewProvider {
    static var previews: some View {
        EmptyViewedMeView()
    }
}
