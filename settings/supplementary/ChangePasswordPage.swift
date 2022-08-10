//
//  ChangePasswordPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct ChangePasswordPage: View {
    let homeRouter = HomeRouter.shared
    @EnvironmentObject var viewModel: SettingsViewModel
    @State var isCurrentPasswordFieldValid = true
    @State var isNewPasswordFieldValid = true
    @State var isConfirmPasswordFieldValid = true
    @State var externalPasswordError = ""
    @State var externalNewPasswordError = ""
    @State var externalConfirmPasswordError = ""
    @State var currentPassword = ""
    @State var newPassword = ""
    @State var confirmNewPassword = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    TextFieldNamingView(text: L10n.currentPasswordUppercase)
                        .padding(.top, 24)
                    currentPasswordView()
                        .padding(.horizontal, 24)
                    Text(L10n.passwordWasSentToYourEmail)
                        .style(.smallBodyRegular)
                        .foregroundColor(.getColor(.bodyTextIcons))
                        .padding(.bottom, 16)
                        .padding(.horizontal, 32)
                    TextFieldNamingView(text: L10n.newPasswordUppercase)
                    newPasswordField()
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)
                    confirmPasswordField()
                        .padding(.bottom, 12)
                        .padding(.horizontal, 24)
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
    
    private func currentPasswordView() -> some View {
        ValidationTextField(
            placeHolder: L10n.currentPassword,
            text: $currentPassword,
            isValid: $isCurrentPasswordFieldValid,
            externalErrorText: $externalPasswordError,
            isSecure: true
        )
    }
    
    private func newPasswordField() -> some View {
        ValidationTextField(
            placeHolder: L10n.newPassword,
            text: $newPassword,
            isValid: $isNewPasswordFieldValid,
            externalErrorText: $externalNewPasswordError,
            isSecure: true
        )
    }
    
    private func confirmPasswordField() -> some View {
        ValidationTextField(
            placeHolder: L10n.yourPassword,
            text: $confirmNewPassword,
            isValid: $isConfirmPasswordFieldValid,
            externalErrorText: $externalConfirmPasswordError,
            isSecure: true
        )
    }
    
    private func onButtonClicked() {
        validateFields()
        if isCurrentPasswordFieldValid,
           !newPassword.isEmpty,
           newPassword != currentPassword,
           newPassword == confirmNewPassword {
            viewModel.changePassword(password: currentPassword,
                                     newPassword: newPassword,
                                     confirmedNewPassword: confirmNewPassword)
            { _ in
                homeRouter.pop()
            }
        }
    }
    
    private func validateFields() {
        validateCurrentPassword()
        validateNewPassword()
        validateConfirmPassword()
    }
    
    private func validateCurrentPassword() {
        guard let passwordError = ValidationService.validateField(
            text: currentPassword,
            rules: [PasswordValidationRule(customErrorText: nil)]
        ) else {
            isCurrentPasswordFieldValid = true
            return
        }
        externalPasswordError = passwordError
        isCurrentPasswordFieldValid = false
    }
    
    private func validateNewPassword() {
        if newPassword == currentPassword {
            externalNewPasswordError = "Your new password must differ from the old one"
            isNewPasswordFieldValid = false
        }
        guard let newPasswordError = ValidationService.validateField(
            text: newPassword,
            rules: [PasswordValidationRule(customErrorText: "Please enter new password")]
        ) else {
            isNewPasswordFieldValid = true
            return
        }
        externalNewPasswordError = newPasswordError
        isNewPasswordFieldValid = false
    }
    
    private func validateConfirmPassword() {
        if !confirmNewPassword.isEmpty, confirmNewPassword != newPassword {
            externalConfirmPasswordError = "Your confirmation password doesn’t match a new password"
            isConfirmPasswordFieldValid = false
        }
        guard let passwordError = ValidationService.validateField(
            text: confirmNewPassword,
            rules: [PasswordValidationRule(customErrorText: "Please enter new password confirmation")]
        ) else {
            isConfirmPasswordFieldValid = true
            return
        }
        externalConfirmPasswordError = passwordError
        isConfirmPasswordFieldValid = false
    }
}

struct ChangePasswordPage_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordPage()
    }
}
