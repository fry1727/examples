//
//  ConfirmDeletionView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 29.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct ConfirmDeletionView: View {
    @State var buttonAction: () -> Void

    var body: some View {
        ZStack {
            Color(.background)
            VStack{
                VStack(alignment: .leading, spacing: 0) {
                    Text("Please, confirm")
                        .setTextStyle(.xLargeTitle)
                        .foregroundColor(Color(.titleTextIcons))
                        .padding(.top, 24)
                    Text("If you delete your account, you will permanently lose your profile, photos, messages and matches, this action cannot be undone.")
                        .setTextStyle(.mediumBodyRegular)
                        .foregroundColor(Color(.subheadText))
                        .padding(.top, 8)
                    Text("Please note that if your subscription is active, it will not be automatically canceled when you delete your account. You will have to cancel it in the subscriptions section on your phone.")
                        .setTextStyle(.mediumBodyRegular)
                        .foregroundColor(Color(.subheadText))
                        .padding(.top, 16)
                }
                .padding(.horizontal, 24)
                Spacer()
                LargeButton(text: "Yes, Delete My Account", style: .normal, action: buttonAction)
                    .padding(.vertical, 24)
            }
        }
    }
}

struct ConfirmDeletionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmDeletionView(buttonAction: {})
    }
}
