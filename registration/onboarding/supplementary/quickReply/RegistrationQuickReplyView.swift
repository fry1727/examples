//
//  RegistrationQuickReplyView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 13.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct RegistrationQuickReplyView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @ObservedObject var quickReplyViewModel = QuickReplyViewModel()
    @State var isSelected: Bool = true
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.quickReply)
                    .style(.largeTitle)
                Text(L10n.dontWasteYourTimeOnMultipleNotifications)
                    .style(.mediumBodyRegular)
                    .foregroundColor(Color(.subheadText))
            }
            .padding(.horizontal, 24)
            Spacer()
            QuickReplyView(quickReplyText: quickReplyViewModel.quickReply.message,
                           isSelected: isSelected)
            .padding(.horizontal, 24)
            .onTapGesture {
                isSelected.toggle()
            }
            Spacer()
            button
        }
        .padding(.top, 78)
        .contentShape(Rectangle())
    }
    
    private var button: some View {
        LargeButton(type: .goOn, showLoader: viewModel.isLoading) {
            once {
                AnalyticsService.logAmplitudeEvent(.quickReply(granted: isSelected))
                if isSelected {
                    quickReplyViewModel.saveQuickReply(id: quickReplyViewModel.quickReply.id)
                }
                viewModel.finishOnboarding()
                viewModel.showPaywallOnRegistration()
            }
        }
        .padding(.bottom, 24)
    }
}

struct RegistrationQuickReplyView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationQuickReplyView()
    }
}
