//
//  RegestrationNameView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 10.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct RegistrationNameView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var isFieldValid = false
    @State private var nameError = ""
    private let nameValidationRules: [ValidationRule] = [NameValidationRule()]

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.whatsYourName)
                    .style(.largeTitle)

                Text(L10n.youCanUserYourRealNameOrNickname)
                    .style(.mediumBodyRegular)
                    .foregroundColor(Color(.subheadText))

                textField
            }
            .padding(.horizontal, 24)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            Spacer()
            button
        }
        .padding(.top, 78)
        .allowsHitTesting(!viewModel.isLoading)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }

    private var textField: some View {
        ValidationTextField(
            placeHolder: L10n.name,
            text: $viewModel.name,
            rules: nameValidationRules,
            isValid: $isFieldValid,
            externalErrorText: $nameError
        )
    }

    private var button: some View {
        LargeButton(
            type: .goOn,
            showLoader: viewModel.isLoading
        ) {
            validateName()
            guard isFieldValid else { return }
            AnalyticsService.logAmplitudeEvent(.stepName)
            viewModel.registerUser {
                onNextClicked()
            }
        }.padding(.bottom, 24)
    }

    func onNextClicked() {
        once {
            viewModel.openNextPage()
            withAnimation {
                viewModel.progress += 1/5
            }
        }
    }

    private func validateName() {
        if viewModel.name.count > 1 {
        guard let nameError = ValidationService.validateField(
            text: viewModel.name, rules: nameValidationRules
        ) else {
            isFieldValid = true
            return
        }
            self.nameError = nameError
            isFieldValid = false
        } else {
            self.nameError = "Minimum 2 characters"
            isFieldValid = false
        }
    }
}

struct RegestrationNameView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationNameView()
    }
}
