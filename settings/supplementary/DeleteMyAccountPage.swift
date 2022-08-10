//
//  DeleteMyAccountPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct DeleteMyAccountPage: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    @State var text = ""
    let homeRouter = HomeRouter.shared
    @State var placeholder: String = L10n.enterReasonHere
    @State var isShowConfirmDeletion = true
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack(spacing: 0) {
                    ZStack {
                        if text.isEmpty {
                            TextEditor(text: $placeholder)
                                .setTextStyle(.largeBodyRegular)
                                .foregroundColor(.getColor(.placeholderFilledText))
                        }
                        FirstResponderTextView(text: $text, isFirstResponder: !isShowConfirmDeletion)
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
                    LargeButton(text: L10n.sendAndDelete, style: .normal, action: {
                        onButtonClicked()
                    })
                    .padding(.vertical, 24)
                }
                if isShowConfirmDeletion {
                    ConfirmDeletionView(buttonAction: { isShowConfirmDeletion.toggle() })
                }
            }
            .navigation(title: L10n.deleteMyAccount, onBackClicked: { homeRouter.pop() })
        }
        .navigationViewStyle(.stack)
    }
    
    private func onButtonClicked() {
        let view = DeleteLastPage()
            .environmentObject(viewModel)
        viewModel.deleteUser(reason: text) {
            homeRouter.push(view: view)
        }
    }
}

struct DeleteMyAccountPage_Previews: PreviewProvider {
    static var previews: some View {
        DeleteMyAccountPage()
    }
}
