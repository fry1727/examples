//
//  RegistrationAddPhotosView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct AddPhotosView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @StateObject var photosViewModel = AddPhotosViewModel()
    @State private var showBottomSheet = false

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.letsAddPhotos)
                    .style(.largeTitle)
                Text(L10n.peopleWithPhotoGet54pMoreMatchesIos)
                    .style(.mediumBodyRegular)
                    .foregroundColor(Color(.subheadText))
            }
            .padding(.horizontal, 24)
            VStack {
                Spacer()
                if !photosViewModel.startedSelection {
                    PhotoRulesView(sex: viewModel.selectedPreference.sex)
                    Spacer()
                    photoButtons
                        .padding(.bottom, 24)
                } else {
                    VStack(spacing: 10) {
                        firstImagesView
                        secondImagesView
                    }
                    .onAppear {
                        viewModel.progress = 1.8
                        viewModel.restoreOnboardingState = true
                    }
                    Spacer()
                    continueButton
                        .padding(.bottom, 24)
                }
            }
        }
        .padding(.top, 78)
        .overlay(ZStack {
            if showBottomSheet && photosViewModel.startedSelection {
                BottomCardSelfSizing(isOpen: $showBottomSheet) {
                    photoButtons
                        .padding(.vertical, 32)
                        .padding(.bottom, UIScreen.screenSafeInsets?.bottom ?? 0)
                        .background(Color.white)
                }
            }
        })
    }

    var firstImagesView: some View {
        HStack(spacing: 10) {
            ForEach(0 ..< 3, id: \.self) { index in
                if let model = photosViewModel.photoModel.safeGet(index) {
                    PhotoView(model: model) {
                        self.photosViewModel.deletePhoto(photoID: model.uploadResponse?.photoId ?? "")
                    } addAction: {
                        self.showBottomSheet = true
                    }
                } else {
                    PhotoView(imageUrl: "") {
                        self.showBottomSheet = true
                    }
                }
            }
        }
    }

    var secondImagesView: some View {
        HStack(spacing: 10) {
            ForEach(3 ..< 6, id: \.self) { index in
                if let model = photosViewModel.photoModel.safeGet(index) {
                    PhotoView(model: model) {
                        self.photosViewModel.deletePhoto(photoID: model.uploadResponse?.photoId ?? "")
                    } addAction: {
                        self.showBottomSheet = true
                    }
                } else {
                    PhotoView(imageUrl: "") {
                        self.showBottomSheet = true
                    }
                }
            }
        }
    }

    var continueButton: some View {
        LargeButton(style: photosViewModel.photoModel.isEmpty ? .disabled : .normal, type: .goOn) {
            guard photosViewModel.startedSelection,
                  photosViewModel.photoModel.contains(where: { $0.status == .loaded }) else { return }
            onContinueClicked()
            AnalyticsService.logAmplitudeEvent(.photoUpload(numberPhotos: photosViewModel.photoModel.count))
        }
    }
    func onContinueClicked() {
        once {
            viewModel.openNextPage()
            withAnimation {
                viewModel.progress += 1/5
            }
        }
    }

    var photoButtons: some View {
        VStack {
            LargeButton(type: .uploadPhoto) {
                guard photosViewModel.photoModel.count <= 6 else { return }
                var selectionLimit = 6 - photosViewModel.photoModel.count
                if selectionLimit == 0 {
                    selectionLimit = 6
                }
                viewModel.router.present(
                    view: ImagePicker(images: $photosViewModel.photoModel,
                                      selectionLimit: selectionLimit)
                    .edgesIgnoringSafeArea(.all))
                showBottomSheet = false
            }
            LargeButton(type: .takePhoto) {
                PermissionsService.shared.requestToGo(.camera, presenter: self.viewModel.router) { status in
                    guard status else { return }
                    viewModel.router.present(
                        view: TakePhotoView(images: $photosViewModel.photoModel)
                            .edgesIgnoringSafeArea(.all))
                }
                showBottomSheet = false
            }
        }
    }
}
