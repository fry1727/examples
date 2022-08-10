//
//  MyProfilePhotoGallery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 23.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct MyProfileGallery: View {
    @Binding var currentIndex: Int
    let onBackClicked: () -> Void

    let homeRouter = HomeRouter.shared
    @ObservedObject var myProfileService = MyProfileService.shared
    @GestureState var draggingOffset: CGSize  = .zero
    @State private var isShowPhotoMenu = false
    @State private var showToast = false
    @State private var toastText = ""
    @State private var isPinching = false

    var body: some View {
        let userPhotos = myProfileService.myProfile?.userProfilePhotos
        ZStack {
            Color.clear
                .background(Color.black)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 0) {
                MyGalleryNavBar(selectedTab: currentIndex,
                                allCount: userPhotos?.count ?? 0,
                                onBackClicked: { onBackClicked() },
                                onEditClicked: { self.isShowPhotoMenu = true })
                    .padding(.vertical, 16)
                TabView(selection: $currentIndex) {
                    ForEach(0 ..< (userPhotos?.count ?? 0), id: \.self) { index in
                        if let photo = userPhotos?.safeGet(index) {
                            AsyncImage(url: photo.photoBigUrl)
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 420, alignment: .center)
                                .clipped()
                                .pinchToZoom(isPinching: $isPinching)
                                .offset(y: draggingOffset.height)
                                .background(
                                    PhotoEditAlert(show: $isShowPhotoMenu,
                                                   makePhotoMainAction: { makePhotoMain(id: photo.id) },
                                                   removePhotoAction: {
                                                       if photo.id == userPhotos?.last?.id {
                                                           currentIndex = 0
                                                       }
                                                       deletePhoto(id: photo.id)
                                                   },
                                                   isMainPhoto: userPhotos?.safeGet(index)?.main ?? false))
                        }
                    }
                }
                .id(userPhotos?.count)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .gesture(
            DragGesture()
                .updating($draggingOffset) { value, outValue, _ in
                    outValue = value.translation
                }
                .onEnded { value in
                    if value.translation.height > 70 {
                        homeRouter.dissmis()
                    }
                }
        )
        .toast(message: toastText, isShowing: $showToast)
    }

    private func makePhotoMain(id: String) {
        myProfileService.makePhotoMain(photoID: id) { _ in
            toastText = L10n.photoHasBeenSetAsMain
            self.showToast = true
        }
    }

    private func deletePhoto(id: String) {
        myProfileService.deletePhoto(photoID: id) { _ in
            toastText = L10n.photoWasRemoved
            self.showToast = true
        }
    }
}

struct PhotoEditAlert: UIViewControllerRepresentable {
    @Binding var show: Bool
    let makePhotoMainAction: () -> Void
    let removePhotoAction: () -> Void
    var isMainPhoto: Bool

    func makeUIViewController(context _: UIViewControllerRepresentableContext<PhotoEditAlert>) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context _: UIViewControllerRepresentableContext<PhotoEditAlert>) {
        if show {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if !isMainPhoto {
                let action = UIAlertAction(
                    title: L10n.setAMainPhoto,
                    style: .default,
                    handler: { _ in
                        makePhotoMainAction()
                    }
                )
                alert.addAction(action)
            }

            let action = UIAlertAction(
                title: L10n.removePhoto,
                style: .destructive,
                handler: { _ in
                    removePhotoAction()
                }
            )
            alert.addAction(action)

            let cancel = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
            alert.addAction(cancel)

            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: {
                    self.show = false
                })
            }
        }
    }
}

struct MyProfileGallery_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileGallery(currentIndex: .constant(1), onBackClicked: {})
    }
}
