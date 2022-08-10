//
//  BasicInformationPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 12.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct BasicInformationPage: View {
    let homeRouter = HomeRouter.shared
    @ObservedObject var myProfileService = MyProfileService.shared
    @State var name: String = MyProfileService.shared.myProfile?.firstName ?? ""
    @State var fullYear: String = .init(MyProfileService.shared.myProfile?.fullYears ?? 18)
    @State var isNameFieldValid = true
    @State var isAgeFieldValid = true
    @State private var selectedOption = MyProfileService.shared.myProfile?.sexAdnPreferences ?? .manSeekingWoman

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    nameTextField()
                        .padding(.top, 20)
                    ageTextField()
                        .padding(.top, 30)
                    Text(L10n.sexAndSearch)
                        .style(.smallBodyRegular)
                        .foregroundColor(.getColor(.inactiveItemTextIcons))
                        .padding(.top, 20)
                    PrefereSelectableView(selectedOption: $selectedOption)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 24)
            }
            .navigation(title: L10n.basicInformation,
                        onBackClicked: { homeRouter.pop() },
                        onSaveClicked: { onSaveClicked() })
        }
        .navigationViewStyle(.stack)
    }

    private func onSaveClicked() {
        if isAgeFieldValid, isNameFieldValid {
            myProfileService.updateProfile(name: name, fullYear: Int(fullYear) ?? 18,
                                           sex: selectedOption.sex.name,
                                           lookingFor: selectedOption.lookingFor.name)
            { _ in
                homeRouter.pop()
            }
        }
    }

    private func ageTextField() -> some View {
        ValidationTextField(
            placeHolder: L10n.age,
            text: $fullYear,
            rules: [AgeValidationRule()],
            isValid: $isNameFieldValid,
            keyboardType: .numberPad
        )
    }

    private func nameTextField() -> some View {
        ValidationTextField(
            placeHolder: L10n.name,
            text: $name,
            rules: [NameValidationRule()],
            isValid: $isAgeFieldValid
        )
    }
}

struct BasicInformationPage_Previews: PreviewProvider {
    static var previews: some View {
        BasicInformationPage()
    }
}
