//
//  EditProfileView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 23.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var myProfileService = MyProfileService.shared
    private let homeRouter = HomeRouter.shared
    private let homePresenter = HomePresenter.shared
    var profile: ProfileDTO? { myProfileService.myProfile }
    @ObservedObject var photosViewModel = AddPhotosViewModel()
    @State private var showBottomSheet = false
    @StateObject var viewModel = EditProfileViewModel()
    @State private var questions: [QuestionModel]

    init() {
        self._questions = State(initialValue: QuestionsViewModel().questions)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if let profile = profile {
                        EditPhotosCell(profile: profile, action: {
                            photosViewModel.startedSelection = true
                            showBottomSheet = true
                        })
                        .padding(.top, 16)

                        AboutMeCell(text: profile.ownWords ?? "") {
                            openAboutMePage()
                        }
                        .padding(.top, 16)

                        MyInterestsCell(myProfile: profile) {
                            openInterestsPage(profile: profile)
                        }
                        .padding(.top, 16)

                        personalInfoSection(profile: profile)
                            .padding(.top, 32)
                    }
                    Spacer()
                }
            }
            .navigation(title: L10n.editProfile, onBackClicked: {
                homeRouter.pop()
            })
        }
        .navigationViewStyle(.stack)
        .overlay(ZStack {
            if showBottomSheet && photosViewModel.startedSelection {
                BottomCardSelfSizing(isOpen: $showBottomSheet) {
                    photoButtons
                }
            }
        })
        .onAppear {
            photosViewModel.onPhotoAdded = {
                myProfileService.fetchMyProfile()
            }
        }
    }

    private func personalInfoSection(profile: ProfileDTO) -> some View {
        VStack(spacing: 0) {
            Text(L10n.myPersonalInformation)
                .setTextStyle(.smallBodyMedium)
                .foregroundColor(.getColor(.primary))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            MatchesAgeCell(profile: profile)
                .padding(.top, 16)
                .padding(.horizontal, 16)

            Divider()
                .padding(.leading, 16)

            EditProfileCell(icon: "filter-city",
                            title: "City",
                            value: profile.city?.name ?? "",
                            callback:  openCityPage)

            Divider()
                .padding(.leading, 16)

            ForEach(Array(questions.enumerated()), id: \.element) { index, value in
                let answer = value.answers.first(where: { profile.socialInfo?.getAnswerId(for: value) == $0.id })
                EditProfileCell(icon: value.icon,
                                iconTemplateMode: true,
                                title: value.questionShort,
                                value: answer?.value ?? "Empty",
                                callback:  { openSocialInfosPage(profile: profile, question: value) })

                if questions.endIndex - 1 != index {
                    Divider()
                        .padding(.leading, 16)

                }
            }
        }
    }

    private var photoButtons: some View {
        VStack {
            LargeButton(type: .uploadPhoto) {
                guard photosViewModel.photoModel.count <= 6 else { return }
                var selectionLimit = 6 - photosViewModel.photoModel.count
                if selectionLimit == 0 {
                    selectionLimit = 6
                }
                let view = ImagePicker(images: $photosViewModel.photoModel,
                                       selectionLimit: selectionLimit)
                    .edgesIgnoringSafeArea(.all)
                homeRouter.present(view: view, transition: .coverVertical)
                showBottomSheet = false
            }
            LargeButton(type: .takePhoto) {
                PermissionsService.shared.requestToGo(.camera, presenter: self.homePresenter) { status in
                    guard status else { return }
                    let view = TakePhotoView(images: $photosViewModel.photoModel)
                        .edgesIgnoringSafeArea(.all)
                    homeRouter.present(view: view, transition: .coverVertical)
                }
                showBottomSheet = false
            }
        }
        .padding(.vertical, 32)
        .padding(.bottom, UIScreen.screenSafeInsets?.bottom ?? 0)
        .background(Color.white)
    }

    private func openAboutMePage() {
        let view = AboutMeView(text: profile?.ownWords ?? "",
                               onBackClicked: { homeRouter.pop() })
        homeRouter.push(view: view)
    }

    private func openInterestsPage(profile: ProfileDTO) {
        let view = MyInterestsView(myProfile: profile,
                                   onBackClicked: { homeRouter.pop() },
                                   onSaveClicked: { homeRouter.pop() })
        homeRouter.push(view: view)
    }

    private func openCityPage() {
        let view = CityPage(onSelected: { newCity in
            viewModel.citySaveButtonPressed(city: newCity)
        })
        homeRouter.push(view: view)
    }

    private func openSocialInfosPage(profile: ProfileDTO, question: QuestionModel) {
        let view = MySocialInfosView(profile: profile,
                                     question: question,
                                     onBackClicked: { homeRouter.pop() })
        homeRouter.push(view: view)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
