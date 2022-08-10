//
//  ChangeEmailPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 13.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct ChangeEmailPage: View {
    let homeRouter = HomeRouter.shared
    @EnvironmentObject var viewModel: SettingsViewModel
    @State var email = MyProfileService.shared.myProfile?.email ?? ""
    @State var newEmail = ""
    @State var password = ""
    @State var externalPasswordError = ""
    @State var externalNewEmailError = ""
    @State var isEmailFieldValid = true
    @State var isPasswordFieldValid = true

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    TextFieldNamingView(text: L10n.currentEmailUppercase)
                        .padding(.top, 24)
                    currentEmailView()
                        .padding([.leading, .trailing, .bottom], 24)
                    TextFieldNamingView(text: L10n.newEmailUppercase)
                    newEmailField()
                        .padding([.leading, .trailing, .bottom], 24)
                    TextFieldNamingView(text: L10n.confirmUppercase)
                    passwordField()
                        .padding(.horizontal, 24)
                    Text(L10n.passwordWasSentToYourEmail)
                        .style(.smallBodyRegular)
                        .foregroundColor(.getColor(.bodyTextIcons))
                        .padding(.top, 4)
                        .padding(.horizontal, 32)
                }
                Spacer()
                LargeButton(text: L10n.save, style: .normal, action: {
                    onButtonClicked()
                })
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigation(title: L10n.changeEmail,
                        onBackClicked: { homeRouter.pop() })
        }
        .navigationViewStyle(.stack)
    }

    private func newEmailField() -> some View {
        ValidationTextField(
            placeHolder: L10n.newEmail,
            text: $newEmail,
            isValid: $isEmailFieldValid,
            externalErrorText: $externalNewEmailError,
            keyboardType: .emailAddress
        )
    }

    private func passwordField() -> some View {
        ValidationTextField(
            placeHolder: L10n.yourPassword,
            text: $password,
            isValid: $isPasswordFieldValid,
            externalErrorText: $externalPasswordError,
            isSecure: true,
            keyboardType: .emailAddress
        )
    }

    private func currentEmailView() -> some View {
        ValidationTextField(
            placeHolder: "",
            text: $email,
            rules: [EmailValidationRule()],
            isValid: $isEmailFieldValid,
            keyboardType: .emailAddress,
            capitalizationType: .none,
            correctionType: .no
        )
        .disabled(true)
    }

    private func onButtonClicked() {
        validateNewEmail()
        validatePasswordEmail()
        if isEmailFieldValid, isPasswordFieldValid,
           email != newEmail,
           !newEmail.isEmpty,
           !password.isEmpty {
            viewModel.changeEmail(email: newEmail, password: password) { _ in
                homeRouter.pop()
            }
        }
    }

    private func validateNewEmail() {
        guard let newEmailError = ValidationService.validateField(
            text: newEmail,
            rules: [EmailValidationRule()]
        ) else {
            isEmailFieldValid = true
            return
        }
        externalNewEmailError = newEmailError
        isEmailFieldValid = false
    }

    private func validatePasswordEmail() {
        if newEmail == email {
            externalPasswordError = "Your new email must differ from the old one"
            isPasswordFieldValid = false
        }
        guard let newPasswordError = ValidationService.validateField(
            text: newEmail,
            rules: [PasswordValidationRule(customErrorText: nil)]
        ) else {
            isPasswordFieldValid = true
            return
        }
        externalPasswordError = newPasswordError
        isPasswordFieldValid = false
    }
}

struct ChangeEmailPage_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailPage()
    }
}
