//
//  EmailRegistrationView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 23.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct RegistrationEmailView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @StateObject var viewModel: RegistrationViewModel

    private let emailValidationRules: [ValidationRule] = [EmailValidationRule()]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                WaveView().foregroundColor(.white).ignoresSafeArea()
                VStack(alignment: .center) {
                    Text(L10n.chatFlirtDate).style(.xLargeTitle)
                    textField
                        .padding(.bottom, 24)
                    Spacer()
                    VStack {
                        LargeButton(
                            text: L10n.joinMeetville,
                            showLoader: viewModel.isLoading,
                            action: {
                                once{
                                    validateEmail()
                                    viewModel.enterEmailButtonPressed(email: viewModel.email) {
                                        if !viewModel.isCurrentUser {
                                            viewModel.router.swipeToBack(false)
                                            viewModel.progress = 2/5
                                            viewModel.router.push(view: OnboardingView()
                                                .ignoresSafeArea(.container)
                                                .environmentObject(viewModel))
                                            AnalyticsService.logAmplitudeEvent(.stepEmail)
                                        }
                                    }
                                }
                            }
                        )
                        loginText
                        Text(L10n.byContinuing)
                            .style(.mediumBodyRegular)
                            .foregroundColor(Color(.darkBackground))
                        termsTexts
                        privacyPolicyText
                            .padding(.bottom, keyboard.currentHeight == 0 ? 24 : 54)
                    }
                }
            }
            .allowsHitTesting(!viewModel.isLoading)
            .padding(.top, geometry.size.height * 0.48)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                VStack{
                    Image("startPageImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .edgesIgnoringSafeArea(.all)
                    Spacer()
                }
            )
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
    
    private var textField: some View {
        ValidationTextField(
            placeHolder: L10n.hintEmail,
            text: $viewModel.email,
            rules: emailValidationRules,
            isValid: $viewModel.isEmailValid,
            validationType: .onFocusing,
            externalErrorText: $viewModel.emailError,
            keyboardType: .emailAddress,
            capitalizationType: .none,
            correctionType: .no
        )
        .padding(.horizontal, 24)
    }
    
    private var loginText: some View {
        HStack(spacing: 2) {
            Text(L10n.haveAccount)
                .style(.mediumBodyRegular)
                .foregroundColor(Color(.darkBackground))
            Text(L10n.signIn)
                .style(.mediumBodyRegular)
                .foregroundColor(Color(.primary))
                .onTapGesture {
                    let email = viewModel.isEmailValid ? viewModel.email : ""
                    let viewModel = LoginViewModel(email: email, router: viewModel.router)
                    self.viewModel.router.push(view: LoginView(viewModel: viewModel))
                }
        }
    }
    
    private var termsTexts: some View {
        HStack(spacing: 5) {
            if let url = URL(string: AppConfigService.shared.termsLink) {
                Link("\(L10n.termsOfUse),", destination: url)
                    .foregroundColor(Color(.primary))
                    .style(.mediumBodyRegular)
            }
            if let url = URL(string: AppConfigService.shared.safetyLink) {
                Link("\(L10n.securityAndCompliance)", destination: url)
                    .foregroundColor(Color(.primary))
                    .style(.mediumBodyRegular)
            }
        }
    }
    
    private var privacyPolicyText: some View {
        HStack(spacing: 0) {
            Text(L10n.andV2)
                .style(.mediumBodyRegular)
                .foregroundColor(Color(.darkBackground))

            if let url = URL(string: AppConfigService.shared.privacyLink) {
                Link("\(L10n.privacyPolicy).", destination: url)
                    .foregroundColor(Color(.primary))
                    .style(.mediumBodyRegular)
            }
        }
    }
    
    private func validateEmail() {
        guard let emailError = ValidationService.validateField(text: viewModel.email, rules: emailValidationRules) else {
            viewModel.isEmailValid = true
            return
        }
        viewModel.emailError = emailError
        viewModel.isEmailValid = false
    }
}

struct EmailRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationEmailView(viewModel: RegistrationViewModel(cityId: ""))
    }
}
