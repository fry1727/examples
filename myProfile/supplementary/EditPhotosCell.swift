//
//  EditProfilePhotoStack.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 22.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct EditPhotosCell: View {
    let profile: ProfileDTO
    let action: () -> Void

    let homeRouter = HomeRouter.shared
    @State var currentIndex = 0

    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if profile.userProfilePhotos.isEmpty != true {
                        ForEach(profile.userProfilePhotos) { userPhoto in
                            Button(action: { onPhotoTap(userPhoto: userPhoto) }) {
                                AsyncImage(url: userPhoto.photoPreviewUrl ?? "")
                                    .frame(width: 97, height: 97)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    if profile.userProfilePhotos.count < 6 {
                        ForEach(0 ... 2, id: \.self) { _ in
                            Button(action: action) {
                                AddPhotoSquare()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private func onPhotoTap(userPhoto: UserProfilePhotos) {
        if let index = profile.userProfilePhotos.firstIndex(of: userPhoto) {
            currentIndex = index
            let view = MyProfileGallery(currentIndex: $currentIndex,
                                        onBackClicked: { homeRouter.dissmis() })
            homeRouter.present(view: view)
        }
    }
}

struct AddPhotoSquare: View {
    var body: some View {
        ZStack {
            Color.white
            Image("add_circle")
                .resizable()
                .frame(width: 31, height: 31)
        }
        .frame(width: 97, height: 97)
        .cornerRadius(4)
        .border(Color.getColor(.border))
    }
}

#if DEBUG
struct EditProfilePhotoStack_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotosCell(profile: mockProfile, action: {})
    }
}
#endif
