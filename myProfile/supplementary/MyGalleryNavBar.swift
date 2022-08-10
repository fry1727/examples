//
//  MyGalleryNavBar.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 24.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct MyGalleryNavBar: View {
    let selectedTab: Int
    let allCount: Int
    let onBackClicked: () -> Void
    let onEditClicked: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                onBackClicked()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.getColor(.textIconsOnBack))
                    .padding(.horizontal, 21)
            }
            Spacer()
            Text("\(selectedTab + 1)/\(allCount)")
                .foregroundColor(Color.white)
            Spacer()
            Button(action: {
                if allCount > 1 {
                    onEditClicked()
                }
            }) {
                Text("Edit")
                    .foregroundColor(allCount > 1 ? .getColor(.textIconsOnBack) : Color.clear)
                    .padding(.horizontal, 16)
            }
        }
    }
}

struct MyGalleryNavBar_Previews: PreviewProvider {
    static var previews: some View {
        MyGalleryNavBar(selectedTab: 1, allCount: 2, onBackClicked: {}, onEditClicked: {})
            .background(Color.black)
    }
}
