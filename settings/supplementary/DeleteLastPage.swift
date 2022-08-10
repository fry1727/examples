//
//  DeleteLastPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct DeleteLastPage: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        ZStack {
            Color.getColor(.primary)
            VStack(spacing: 16) {
                Image("heart")
                    .frame(width: 50, height: 44)
                Text(L10n.yourAccountDeleted)
                    .foregroundColor(.getColor(.textIconsOnBack))
                    .style(.mediumBodyRegular)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                viewModel.logOut()
            }
        }
    }
}

struct DeleteLastPage_Previews: PreviewProvider {
    static var previews: some View {
        DeleteLastPage()
    }
}
