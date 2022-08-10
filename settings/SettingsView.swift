//
//  SettingsView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 7.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    let homeRouter = HomeRouter.shared
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Group {
                        SettingsButton(buttonText: L10n.editBasicInformation, buttonAction: {
                            goToEditBasicInformation()
                        })
                        Divider()
                            .padding(.leading, 16)
                        SettingsButton(buttonText: L10n.contactUs, buttonAction: {
                            goToContactUs()
                        })
                        Divider()
                            .padding(.leading, 16)
                        SettingsButton(buttonText: L10n.safetyGuide, buttonAction: {
                            goToSafetyGuide()
                        })
                        Divider()
                            .padding(.leading, 16)
                        SettingsButton(buttonText: L10n.privacyPolicy, buttonAction: {
                            goToPrivatePolicy()
                        })
                        Divider()
                            .padding(.leading, 16)
                    }
                    Group {
                        SettingsButton(buttonText: L10n.termsOfUse, buttonAction: {
                            goToTermsOfUse()
                        })
                        Divider()
                            .padding(.leading, 16)
                        SettingsButton(buttonText: L10n.accountSettings, buttonAction: {
                            goToAccountSettings()
                        })
                    }
                }
                .padding(.top, 16)

                Spacer()
                VStack{
                    Image("MeetvilleLogo")
                        .resizable()
                        .frame(width: 26, height: 24)
                    Text("\(L10n.version) \(Bundle.appVersion)")
                        .style(.largeBodyRegular)
                        .foregroundColor(.getColor(.subheadText))
                }
                .padding(.bottom, 8)
            }
            .frame(maxHeight: .infinity)
            .navigation(title: L10n.settings, onBackClicked: {
                homeRouter.pop()
            })
        }
        .navigationViewStyle(.stack)
    }

    private func goToEditBasicInformation() {
        let view = BasicInformationPage()
            .environmentObject(viewModel)
        homeRouter.push(view: view)
    }

    private func goToContactUs() {
        let view = ContactUsPage()
            .environmentObject(viewModel)
        homeRouter.push(view: view)
    }

    private func goToSafetyGuide() {
        guard let urlShare = URL(string: viewModel.safetyLink) else { return }
        let view = WebViewSettingsPage(url: urlShare, header: L10n.safetyGuide)
        homeRouter.push(view: view)
    }

    private func goToPrivatePolicy() {
        guard let urlShare = URL(string: viewModel.privacyLink) else { return }
        let view = WebViewSettingsPage(url: urlShare, header: L10n.privacyPolicy)
        homeRouter.push(view: view)
    }

    private func goToTermsOfUse() {
        guard let urlShare = URL(string: viewModel.termsLink) else { return }
        let view = WebViewSettingsPage(url: urlShare, header: L10n.termsOfUse)
        homeRouter.push(view: view)
    }

    private func goToAccountSettings() {
        let view = AccountSettingsPage()
            .environmentObject(viewModel)
        homeRouter.push(view: view)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
