//
//  UserProfileGalleryNavBar.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 28.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct UserProfileGalleryHeader: View {
    let selectedTab: Int
    let allCount: Int
    let onCloseClicked: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                onCloseClicked()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.getColor(.textIconsOnBack))
                    .padding(.horizontal, 21)
            }
            Spacer()
            Text("\(selectedTab + 1)/\(allCount)")
                .foregroundColor(Color.white)
                .setTextStyle(.smallTitle)
            Spacer()
            Button(action: { log() }) {
                Text("Edit")
                    .foregroundColor(Color.clear)
                    .padding(.horizontal, 16)
            }
        }
    }
}

struct UserProfileGalleryNavBar_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileGalleryHeader(selectedTab: 1, allCount: 1, onCloseClicked: {})
    }
}
