//
//  ContactUsPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 7.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct ContactUsPage: View {
    let homeRouter = HomeRouter.shared
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        let reasons = viewModel.feedbackReasons
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                TextFieldNamingView(text: "SELECT REASON")
                    .padding(.top, 16)
                ForEach(reasons, id: \.self) { reason in
                    SettingsButton(buttonText: reason.text, buttonAction: {
                        clickOnFeedbackReason(title: reason.text, reason: reason.id)
                    })
                    if reason != reasons.last {
                        Divider()
                            .padding(.leading, 16)
                    }
                }
                Spacer()
            }
            .navigation(title: L10n.contactUs, onBackClicked: {
                homeRouter.pop()
            })
        }
        .navigationViewStyle(.stack)
    }

    private func clickOnFeedbackReason(title: String, reason: String) {
        let view = ContactUsMessagePage(title: title, reason: reason)
            .environmentObject(viewModel)
        homeRouter.push(view: view)
    }
}

struct ContactUsPage_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsPage()
    }
}
