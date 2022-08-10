//
//  AccountSettingsPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct AccountSettingsPage: View {
    let homeRouter = HomeRouter.shared
    @EnvironmentObject var viewModel: SettingsViewModel
    @ObservedObject var myProfileService = MyProfileService.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SettingsButton(buttonText: L10n.changeEmail, buttonAction: {
                    goToChangeEmail()
                })
                Divider()
                    .padding(.leading, 16)
                SettingsButton(buttonText: L10n.changePassword, buttonAction: {
                    goToChangePassword()
                })
                Divider()
                    .padding(.leading, 16)
                if myProfileService.myProfile?.sexAdnPreferences == .womanSeekingMan {
                    SettingsButton(buttonText: L10n.quickReply, buttonAction: {
                        goToQuickReply()
                    })
                    Divider()
                        .padding(.leading, 16)
                }
                SettingsButton(buttonText: L10n.deleteMyAccount, buttonAction: {
                    goToDeleteMyAccount()
                })
                Spacer()
                logOutButton
                    .padding(.bottom, 42)
            }
            .padding(.top, 16)
            .navigation(title: L10n.accountSettings, onBackClicked: {
                homeRouter.pop()
            })
        }
        .navigationViewStyle(.stack)
    }

    private func goToChangeEmail() {
        let view = ChangeEmailPage()
            .environmentObject(viewModel)
        homeRouter.push(view: view)
    }

    private func goToChangePassword() {
        let view = ChangePasswordPage()
            .environmentObject(viewModel)
        homeRouter.push(view: view)
    }

    private func goToDeleteMyAccount() {
        let view = DeleteMyAccountPage()
            .environmentObject(viewModel)
        homeRouter.push(view: view)
    }

    private func goToQuickReply() {
        let view = QuickReplyPage(replyId: myProfileService.myProfile?.autoreply ?? "")
            .environmentObject(viewModel)
        homeRouter.push(view: view)
    }

    private var logOutButton: some View {
        return Button {
            viewModel.showLogOutAlert { succes in
                if succes == true {
                    viewModel.logOut()
                }
            }
        } label: {
            Text(L10n.logOut)
                .style(.mediumBody)
                .foregroundColor(.getColor(.inactiveItemTextIcons))
        }
    }
}

struct AccountSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsPage()
    }
}
