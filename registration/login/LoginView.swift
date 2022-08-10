//
//  LoginView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 12.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    private let emailValidationRules: [ValidationRule] = [EmailValidationRule()]
    private let passwordValidationRules: [ValidationRule] = [PasswordValidationRule(customErrorText: nil)]

    var body: some View {
        VStack(alignment: .leading) {
            backButton
            Spacer()
            VStack(alignment: .center, spacing: 8) {
                ScrollView {
                    Text(L10n.chatFlirtDate)
                        .style(.xLargeTitle)
                        .padding(.bottom, 12)
                    emailField
                    passwordField
                    Group {
                        Text(L10n.askThePasswordWasSentToYourEmailIfYouCantFindItYouCan)
                            + Text(" ") + Text(L10n.resetYourPasswordIos)
                            .foregroundColor(Color(.primary))
                    }
                    .font(.system(size: 12))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    .onTapGesture {
                        viewModel.router.push(view: RestorePasswordView().environmentObject(viewModel))
                    }
                    Spacer()
                }
                loginButton
            }
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
            externalErrorText: $viewModel.emailError,
            keyboardType: .emailAddress,
            capitalizationType: .none,
            correctionType: .no
        )
        .padding(.horizontal, 24)
    }

    private var passwordField: some View {
        ValidationTextField(
            placeHolder: L10n.password,
            text: $viewModel.password,
            rules: passwordValidationRules,
            isValid: $isPasswordValid,
            externalErrorText: $viewModel.passwordError,
            isSecure: true
        )
        .padding(.horizontal, 24)
    }

    private var loginButton: some View {
        LargeButton(type: .signIn,
                    showLoader: viewModel.isLoading) {
            validateEmail()
            validatePassword()
            guard isEmailValid, isPasswordValid else { return }
            viewModel.login {
                viewModel.router.navigationController?.setViewControllers([HomeViewController()], animated: false)
                MyProfileService.shared.fetchMyProfile()
                BlockReportService.shared.refreshBlockedUsers()
                APNsClient.shared.registerForRemoteNotifications()
                SocketClient.shared.reconnect()
            }
        }.padding(.bottom, 24)
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
        viewModel.emailError = emailError
        isEmailValid = false
    }

    private func validatePassword() {
        guard let passwordError = ValidationService.validateField(
            text: viewModel.password,
            rules: passwordValidationRules
        ) else {
            isPasswordValid = true
            return
        }
        viewModel.passwordError = passwordError
        isPasswordValid = false
    }
}
