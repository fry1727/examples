//
//  LikedMeView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct LikedMeView: View {
    @ObservedObject var viewsService = NotificationsService.shared
    @ObservedObject var myProfileService = MyProfileService.shared
    private let subscriptionsPresenter = SubscriptionsPresenter.shared
    
    var body: some View {
        Group {
            if viewsService.likedMePeople.isEmpty && viewsService.likedMeIsLoading {
                ActivityIndicatorView()
            } else if viewsService.likedMePeople.isEmpty {
                EmptyLikedMeView()
            } else {
                ZStack {
                    NotificationsControllerView(notificationType: .likedMe)
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

struct LikedMeView_Previews: PreviewProvider {
    static var previews: some View {
        LikedMeView()
    }
}
