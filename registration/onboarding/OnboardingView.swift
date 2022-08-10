//
//  OnboardingView.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 29.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var pages: [AnyView] = []

    var body: some View {
        ZStack(alignment: .top) {
            if !pages.isEmpty {
                pages[viewModel.currentPage]
                    .transition(.backslide)

                WalkthroughPageIndicator(divisions: 5,
                                         currentDivision: viewModel.progress,
                                         colors: viewModel.currentOnbaordingPage.progressColors)
                    .padding(.horizontal, 39)
                    .padding(.top, 30)
            }
        }
        .padding(.top, UIScreen.screenSafeInsets?.top ?? 5)
        .padding(.bottom, UIScreen.screenSafeInsets?.bottom ?? 5)
        .environmentObject(viewModel)
        .onAppear {
            pages = viewModel.pages.map { $0.view }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
