//
//  WhatPreferPage.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 29.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct WhatPreferPage: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        Color.clear
            .overlay(Text("Who do you prefer?"))
            .contentShape(Rectangle())
            .onTapGesture(perform: onNextClicked)
            .onAppear {
                viewModel.progress = 2/5
            }
    }

    func onNextClicked() {
        once {
            viewModel.openNextPage()
            withAnimation {
                viewModel.progress += 1/5
            }
        }
    }
}
