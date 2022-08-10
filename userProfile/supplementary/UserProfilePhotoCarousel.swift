//
//  ImageGallery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 17.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Kingfisher
import SwiftUI

struct UserProfilePhotoCarousel: View {
    let profilePhotos: [UserProfilePhotos]
    let onPhotoClicked: () -> Void
    @Binding var currentIndex: Int

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                VerticalCarousel(pages: profilePhotos.map {
                    AsyncImage(url: $0.photoBigUrl)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .onTapGesture {
                            onPhotoClicked()
                        }
                }, index: $currentIndex)

                LinearGradient(colors: [.clear, .black],
                               startPoint: .top, endPoint: .bottom)
                .opacity(0.5)
                .frame(height: 100)
                .allowsHitTesting(false)
                
                if profilePhotos.count > 1 {
                    gradientIndicator
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .allowsHitTesting(false)
                }
            }
            .cornerRadius(14)
        }
        .onAppear {
            DispatchQueue.global().async {
                precachePhotos()
            }
        }
    }

    private var gradientIndicator: some View {
        return HStack {
            Spacer()
            ZStack(alignment: .leading) {
                Color.Gradients.clearLeadingBlackTrailingGradient
                    .opacity(0.5)
                CastomIndicator(count: profilePhotos.count, current: $currentIndex)
                    .padding()
            }
            .frame(width: 26)
        }
    }

    private func precachePhotos() {
        let urls: [URL] = profilePhotos
            .compactMap { $0.photoBigUrl }
            .compactMap { URL(string: $0) }
        let urlsToPrecache = Array(urls.prefix(3))
        let prefetcher = ImagePrefetcher(urls: urlsToPrecache)
        prefetcher.start()
    }
}

struct CastomIndicator: View {
    var count: Int
    @Binding var current: Int

    var body: some View {
        VStack(spacing: 4) {
            ForEach(0 ..< count, id: \.self) { index in
                Rectangle()
                    .fill(current == index ? Color.getColor(.background) : Color.getColor(.background).opacity(0.5))
                    .frame(width: 2)
                    .cornerRadius(2)
            }
        }
    }
}

struct ImageGallery_Previews: PreviewProvider {
    static var previews: some View {
        let profilePhotos: [UserProfilePhotos] = []
        UserProfilePhotoCarousel(profilePhotos: profilePhotos, onPhotoClicked: {}, currentIndex: .constant(1))
    }
}
