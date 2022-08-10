//
//  RegestrationAgeView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 10.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct RegistrationAgeView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var isFieldValid = false
    @State private var ageError = ""
    @State private var age = ""
    private let ageValidationRules: [ValidationRule] = [AgeValidationRule()]

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.howOldAreYou)
                    .style(.largeTitle)

                Text(L10n.toFindMoreReliableMatchesForYouWeNeedToKnowYourAge)
                    .style(.mediumBodyRegular)
                    .foregroundColor(Color(.subheadText))

                textField
            }.padding(.horizontal, 24)
            Spacer()
            button
        }
        .padding(.top, 78)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }

    private var textField: some View {
        ValidationTextField(
            placeHolder: L10n.age,
            text: $age,
            rules: [AgeValidationRule()],
            isValid: $isFieldValid,
            validationType: .onFocusing,
            externalErrorText: $ageError,
            keyboardType: .numberPad
        )
        .padding(.top, 16)
    }

    private var button: some View {
        LargeButton(type: .goOn) {
            onNextClicked()
        }.padding(.bottom, 24)
    }

    private func validateAge() {
        guard let ageError = ValidationService.validateField(text: age, rules: ageValidationRules) else {
            isFieldValid = true
            return
        }
        self.ageError = ageError
        isFieldValid = false
    }

    func onNextClicked() {
        once {
            validateAge()
            guard isFieldValid,
                  let ageNumber = Int(age) else { return }
            viewModel.age = ageNumber
            AnalyticsService.logAmplitudeEvent(.stepAge(fullYears: ageNumber))
                viewModel.openNextPage()
            withAnimation {
                viewModel.progress += 1/5
            }
        }
    }
}

struct RegestrationAgeView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationAgeView()
    }
}
