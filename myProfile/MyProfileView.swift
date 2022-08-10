//
//  MyProfileView.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 15.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct MyProfileView: View {
    let homeRouter = HomeRouter.shared
    @ObservedObject var myProfileService = MyProfileService.shared
    var profile: ProfileDTO? { myProfileService.myProfile }
    @State private var currentIndex = 0

    var body: some View {
        NavigationView {
            VStack {
                if let profile = profile {
                    AvatarCircleView(imageUrl: profile.mainPhotoPreview,
                                     sex: profile.sex)
                        .onTapGesture {
                            if profile.userProfilePhotos.isNotEmpty {
                                goToProfilePhotos()
                            }
                        }
                    Text("\(profile.firstName ?? ""), \(profile.fullYears ?? 18)")
                    EditProfileButton(action: {
                        goToEditProfile()
                    })
                }
            }
            .navigation(title: L10n.myProfile, onSettingClicked: {
                goToSettings()
            })
        }
        .navigationViewStyle(.stack)
    }

    private func goToProfilePhotos() {
        let view = MyProfileGallery(currentIndex: $currentIndex,
                                    onBackClicked: { homeRouter.dissmis() })
        homeRouter.present(view: view)
    }

    private func goToEditProfile() {
        let view = EditProfileView()
        homeRouter.push(view: view)
    }

    private func goToSettings() {
        let view = SettingsView()
        homeRouter.push(view: view)
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
