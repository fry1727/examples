//
//  ContactUsMessagePage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 7.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct ContactUsMessagePage: View {
    let title: String
    let reason: String

    @EnvironmentObject var viewModel: SettingsViewModel
    @State var text = ""
    let homeRouter = HomeRouter.shared
    @State var placeholder: String = L10n.pleaseDescribeYourQuestionInDetails

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    if text.isEmpty {
                        TextEditor(text: $placeholder)
                            .setTextStyle(.largeBodyRegular)
                            .foregroundColor(.getColor(.placeholderFilledText))
                    }
                    FirstResponderTextView(text: $text, isFirstResponder: true)
                        .opacity(text.isEmpty ? 0.25 : 1)
                        .onChange(of: text, perform: { value in
                            if value.count > 200 {
                                text = String(value.prefix(200))
                            }
                        })
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                Spacer()
                LargeButton(text: L10n.send, style: text.count < 5 ? .disabled : .normal, action: {
                    onSaveClicked()
                })
                .disabled(text.count < 5)
                .padding(.vertical, 24)
            }
            .navigation(title: title, onBackClicked: { homeRouter.pop() })
        }
        .navigationViewStyle(.stack)
    }

    private func onSaveClicked() {
        viewModel.contactUsMessageSent(text: text, reasonId: reason) { _ in
            homeRouter.pop()
        }
    }
}

struct ContactUsMessagePage_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsMessagePage(title: "", reason: "")
    }
}
