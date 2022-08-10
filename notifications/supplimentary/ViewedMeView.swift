//
//  ViewdMeView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 10.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct ViewedMeView: View {
    @ObservedObject var viewsService = NotificationsService.shared
    @ObservedObject var myProfileService = MyProfileService.shared
    private let subscriptionsPresenter = SubscriptionsPresenter.shared
    
    var body: some View {
        Group {
            if viewsService.viewedMePeople.isEmpty && viewsService.viewedMeIsLoading {
                ActivityIndicatorView()
            } else if viewsService.viewedMePeople.isEmpty {
                EmptyViewedMeView()
            } else {
                ZStack {
                    NotificationsControllerView(notificationType: .viewedMe)
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

struct ViewdMeView_Previews: PreviewProvider {
    static var previews: some View {
        ViewedMeView()
    }
}
