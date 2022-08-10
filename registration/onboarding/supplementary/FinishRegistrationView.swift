//
//  FinishRegistrationView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct FinishRegistrationView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        ZStack {
            Color(.primary)
            contentView
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.loginUser()
        }
    }

    var contentView: some View {
        VStack(spacing: 8) {
            Image("launchScreenImage")
            Text(L10n.congratulationsPoint)
                .style(.largeTitle)
                .foregroundColor(Color(.textIconsOnBack))
                .padding(.top, 8)
            Text(L10n.yourAccountHasBeenSuccessfullyCreated)
                .style(.mediumBodyRegular)
                .foregroundColor(Color(.textIconsOnBack))
            if viewModel.isSubscriptionPurchased {
                Text(L10n.fullAccessIsAvailable)
                .style(.mediumBodyRegular)
                .foregroundColor(Color(.textIconsOnBack))
                .padding(.top, -4)
            }
        }
    }
}

struct FinishRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        FinishRegistrationView()
    }
}
