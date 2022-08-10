//
//  FavedMeView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct FavedMeView: View {
    @ObservedObject var viewsService = NotificationsService.shared
    @ObservedObject var myProfileService = MyProfileService.shared
    private let subscriptionsPresenter = SubscriptionsPresenter.shared
    
    var body: some View {
        Group {
            if viewsService.favedMePeople.isEmpty && viewsService.favedMeIsLoading {
                ActivityIndicatorView()
            } else if viewsService.favedMePeople.isEmpty {
                EmptyFavedMeView()
            } else {
                ZStack {
                    NotificationsControllerView(notificationType: .favedMe)
                    if !(myProfileService.isVip) {
                        UnlockButton(action: showPaywall, text: L10n.seeWhoViewedYou)
                    }
                }
            }
        }
    }
    
    private func showPaywall() {
        subscriptionsPresenter.showPaywall(page: .seeWhoInterested,
                                           reason: .notifications)
    }
}

struct FavedMeView_Previews: PreviewProvider {
    static var previews: some View {
        FavedMeView()
    }
}
