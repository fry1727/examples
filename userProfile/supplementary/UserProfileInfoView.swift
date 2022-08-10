//
//  ProfileInfoView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 20.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct UserProfileInfoView: View {
    let profile: ProfileDTO

    var body: some View {
        VStack(alignment: .leading) {
            UserPersonalInformation(profile: profile)
                .padding(.horizontal, 24)
            if let ownWords = profile.ownWords {
                AboutMe(aboutMeText: ownWords)
                    .padding(.horizontal, 24)
                    .padding(.top, UIScreen.isSmallDevice ? 4 : 18)
            }
            UserInterestsView(profile: profile)
                .padding(.horizontal, 24)
                .padding(.top, UIScreen.isSmallDevice ? 4 : 18)
        }
    }
}

struct AboutMe: View {
    let aboutMeText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L10n.aboutMe)
                .setTextStyle(.mediumBody)
                .foregroundColor(.getColor(.primary))
                .padding(.vertical, 8)
            Text(aboutMeText)
                .setTextStyle(.largeBodyRegular)
                .multilineTextAlignment(.leading)
        }
    }
}

#if DEBUG
    struct ProfileInfoView_Previews: PreviewProvider {
        static var previews: some View {
            UserProfileInfoView(profile: mockProfile)
        }
    }
#endif
