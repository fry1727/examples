//
//  QuickReplyPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 13.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct QuickReplyPage: View {
    let homeRouter = HomeRouter.shared
    var quickReplyViewModel = QuickReplyViewModel()
    @State var replyId: String
    var listOfReplies: [QuickReplyDTO] { quickReplyViewModel.repliesForSettings() }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                TextFieldNamingView(text: L10n.chooseQuickReplyAnswer)
                    .padding(.top, 16)
                QuickReplySelectableView(selectedReply: $replyId, listOfReplies: listOfReplies)
                Spacer()
                LargeButton(text: L10n.save, style: .normal, action: {
                    onButtonClicked()
                })
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigation(title: L10n.quickReply, onBackClicked: {
                homeRouter.pop()
            })
        }
        .navigationViewStyle(.stack)
    }

    private func onButtonClicked() {
        quickReplyViewModel.saveQuickReply(id: replyId)
        homeRouter.pop()
    }
}

struct QuickReplyPage_Previews: PreviewProvider {
    static var previews: some View {
        QuickReplyPage(replyId: "")
    }
}

struct QuickReplySelectableView: View {
    @Binding var selectedReply: String
    let listOfReplies: [QuickReplyDTO]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(listOfReplies, id: \.id) { reply in
                SelectorButton(text: reply.message,
                               isSelected: selectedReply == reply.id,
                               action: {
                    if selectedReply == reply.id {
                        selectedReply = ""
                    } else {
                        selectedReply = reply.id
                    }
                })
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
    }
}

