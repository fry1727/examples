//
//  UserProfilePhotoGallery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 21.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct UserProfileGallery: View {
    let profilePhotos: [UserProfilePhotos]
    @Binding var currentIndex: Int
    let onBackClicked: () -> Void
    @GestureState var draggingOffset: CGSize  = .zero
    @State private var offset = CGSize.zero
    @State private var backgroundAlpha = 1.0
    @State private var isPinching: Bool = false
    @State private var isClosing = false

    var body: some View {
        ZStack {
            Color.black.opacity(backgroundAlpha).ignoresSafeArea()

            VStack(spacing: 0) {
                UserProfileGalleryHeader(selectedTab: currentIndex,
                                         allCount: profilePhotos.count,
                                         onCloseClicked: { onBackClicked() })
                .padding(.vertical, 12)
                .opacity(offset == .zero ? 1 : 0)
                .frame(height: isPinching ? 0 : nil)
                .clipped()

                PagesView(pages: profilePhotos.map { photo in
                    AsyncImage(url: photo.photoBigUrl ?? "")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.screenWidth, height: 420)
                        .clipped()
                        .pinchToZoom(isPinching: $isPinching)

                }, currentPage: $currentIndex, enableScroll: true)
                .offset(y: offset.height)
                .id(profilePhotos.count)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .statusBar(hidden: isPinching)
        .gesture(
            DragGesture()
                .updating($draggingOffset) { value, outValue, _ in
                    outValue = value.translation
                }
                .onEnded { _ in
                    if offset.height > 70 {
                        isClosing = true
                        withAnimation {
                            offset = CGSize(width: 0, height: UIScreen.screenHeight)
                        }
                    } else {
                        withAnimation {
                            offset = .zero
                        }
                    }
                }
        )
        .onChange(of: draggingOffset) { _ in
            if !isClosing {
                offset = draggingOffset
            }
        }
        .onChange(of: offset) { _ in
            backgroundAlpha = max(1 - offset.height / 70.0, 0)
            if offset.height == UIScreen.screenHeight {
                onBackClicked()
            }
        }
    }
}

struct UserProfileGallery_Previews: PreviewProvider {
    static var previews: some View {
        let profilePhotos: [UserProfilePhotos] = []
        UserProfileGallery(profilePhotos: profilePhotos, currentIndex: .constant(1), onBackClicked: {})
    }
}
