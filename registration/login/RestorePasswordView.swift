//
//  RestorePasswordView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct RestorePasswordView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @State private var emailError = ""
    @State private var isEmailValid = false
    private let emailValidationRules: [ValidationRule] = [EmailValidationRule()]

    var body: some View {
        VStack(alignment: .leading) {
            backButton
            VStack(alignment: .center, spacing: 8) {
                Text(L10n.chatFlirtDate)
                    .style(.xLargeTitle)
                    .padding(.bottom, 12)
                VStack(alignment: .leading) {
                    emailField
                    Text(L10n.weWillSendNewPasswordOnYourEmail)
                        .style(.smallBodyRegular)
                        .padding(.horizontal, 32)
                }
                Spacer()
                LargeButton(type: .newPassword,
                            showLoader: viewModel.isLoading) {
                    validateEmail()
                    guard isEmailValid else { return }
                    viewModel.remindPassword()
                }
                .padding(.bottom, 24)
            }
            .padding(.top, 24)
        }
        .allowsHitTesting(!viewModel.isLoading)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }

    private var emailField: some View {
        ValidationTextField(
            placeHolder: L10n.hintEmail,
            text: $viewModel.email,
            rules: emailValidationRules,
            isValid: $isEmailValid,
            validationType: .onFocusing,
            externalErrorText: $emailError,
            keyboardType: .emailAddress,
            capitalizationType: .none,
            correctionType: .no
        )
        .padding(.horizontal, 24)
    }

    private var backButton: some View {
        Button(action: {
            self.viewModel.router.pop()
        }) { Image("back") }
            .frame(width: 40, height: 40)
            .padding(.leading, 10)
    }

    private func validateEmail() {
        guard let emailError = ValidationService.validateField(
            text: viewModel.email,
            rules: emailValidationRules
        ) else {
            isEmailValid = true
            return
        }
        self.emailError = emailError
        isEmailValid = false
    }
}

struct RestorePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RestorePasswordView().environmentObject(
            LoginViewModel(email: "", router: RegistrationRouter()))
    }
}
