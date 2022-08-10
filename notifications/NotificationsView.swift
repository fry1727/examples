//
//  ViewsView.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 15.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Core
import SwiftUI

struct NotificationsView: View {
    @State private var tabs: [SegmentedTab] = [.init(tab: .likedMe),
                                               .init(tab: .viewedMe),
                                               .init(tab: .favedMe)]
    @State private var tabViews: [NotificationTab] = [.likedMe, .viewedMe, .favedMe]
    @State private var selectedTab = 0
    @State private var isFirstAppear = true
    
    @StateObject var viewsService = NotificationsService.shared
    @StateObject var myProfileService = MyProfileService.shared
    @StateObject var notificationsRouter = NotificationsRouter.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                segmentedTabs
                TabView(selection: $selectedTab) {
                    ForEach(tabViews.indices, id: \.self) { index in
                        tabViews[index].view
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigation(title: "Notifications", divider: false)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if isFirstAppear {
                fetchData()
                isFirstAppear = false
            }
        }
        .onTabOpen { tab in
            guard tab == .notifications else { return }
            updateTabsBage()
            logOpenTabEvent(index: selectedTab)
        }
        .onChange(of: notificationsRouter.openTabIndex) { newTabIndex in
            selectedTab = newTabIndex
        }
        .onChange(of: myProfileService.myProfile?.newNotificationsCount) { _ in
            updateTabsBage()
        }
    }
    
    @ViewBuilder
    private var segmentedTabs: some View {
        SegmentedTabBar(tabs: tabs,
                        selection: $selectedTab)
        .padding(.horizontal, 16)
        .padding(.bottom, 13)
        .padding(.top, 3)
        .onChange(of: selectedTab) { newValue in
            logOpenTabEvent(index: newValue)
        }
        Divider()
            .background(Color(.divider))
    }
    
    private func fetchData() {
        viewsService.loadLikededMePeople(refresh: true)
        viewsService.loadViewedMePeople(refresh: true)
        viewsService.loadFavedMePeople(refresh: true)
    }
    
    private func logOpenTabEvent(index: Int) {
        switch index {
        case NotificationTab.likedMe.rawValue:
            AnalyticsService.logAmplitudeEvent(.likedMeView)
        case NotificationTab.viewedMe.rawValue:
            AnalyticsService.logAmplitudeEvent(.viewedMeView)
        case NotificationTab.favedMe.rawValue:
            AnalyticsService.logAmplitudeEvent(.favedMeView)
        default:
            AnalyticsService.logAmplitudeEvent(.likedMeView)
        }
    }
    
    private func updateTabsBage() {
        tabs[NotificationTab.likedMe.rawValue].badge = myProfileService.myProfile?.newPhotoLikedCount ?? 0 > 0
        tabs[NotificationTab.viewedMe.rawValue].badge = myProfileService.myProfile?.newViewedCount ?? 0 > 0
        tabs[NotificationTab.favedMe.rawValue].badge =
        myProfileService.myProfile?.newFavedCount ?? 0 > 0
    }
}

struct ViewsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
