//
//  ViewsService.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 5.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

final class NotificationsService: ObservableObject {
    static let shared = NotificationsService()
    
    @Published var likedMeIsLoading = false
    @Published var likedMePeople: [ProfileDTO] = []
    var canLoadMoreLikes = true
    
    @Published var viewedMeIsLoading = false
    @Published var viewedMePeople: [ProfileDTO] = []
    var canLoadMoreViews = true
    
    @Published var favedMeIsLoading = false
    @Published var favedMePeople: [ProfileDTO] = []
    var canLoadMoreFaves = true
    
    let myProfileService = MyProfileService.shared
    let socketClient = SocketClient.shared
    let apnsClient = APNsClient.shared
    let homeRouter = HomeRouter.shared
    let homePresenter = HomePresenter.shared
    let subscriptionsPresenter = SubscriptionsPresenter.shared
    let notificationsRouter = NotificationsRouter.shared
    
    private var profileToOpenFromNotification: ID?
    private let pageSize = 20, technicalLimit = 1000
    private var cancellables: [AnyCancellable] = []
    
    private init() {
        observeIncomingMessages()
    }
    
    func reloadTab(tabType: NotificationTab ) {
        switch tabType {
        case .likedMe:
            self.loadLikededMePeople(refresh: true)
        case .viewedMe:
            self.loadViewedMePeople(refresh: true)
        case .favedMe:
            self.loadFavedMePeople(refresh: true)
        }
    }
    
    func loadViewedMePeople(refresh: Bool = false) {
        guard refresh || canLoadMoreViews, !viewedMeIsLoading else { return }
        viewedMeIsLoading = true
        let excludedIds = refresh ? [] : viewedMePeople.map { $0.id }
        
        let query = GetNotificationsQuery(first: pageSize, notificationType: .viewedMe, excludedIds: excludedIds)
        HTTPClient.shared.request(query: query, waitsForConnectivity: true)
            .retry(2, delay: 1, scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.viewedMeIsLoading = false
            }, receiveValue: { value in
                defer {
                    let isLimitReached = self.pageSize != value.users.count
                    let isTechnicalLimitReached = self.viewedMePeople.count + self.pageSize >= self.technicalLimit
                    self.canLoadMoreViews = !isLimitReached && !isTechnicalLimitReached
                }
                if refresh {
                    self.viewedMePeople = Array(value.users)
                    self.handleProfileToOpenFromNotification(tabType: .viewedMe)
                } else {
                    self.viewedMePeople.append(contentsOf: value.users)
                }
                log("refresh=\(refresh) viewMePeople=\(self.viewedMePeople.count)")
            })
            .store(in: &cancellables)
    }
    
    func loadFavedMePeople(refresh: Bool = false) {
        guard refresh || canLoadMoreFaves, !favedMeIsLoading else { return }
        favedMeIsLoading = true
        let excludedIds = refresh ? [] : favedMePeople.map { $0.id }
        
        let query = GetNotificationsQuery(first: pageSize, notificationType: .favedMe,
                                          excludedIds: excludedIds)
        HTTPClient.shared.request(query: query, waitsForConnectivity: true)
            .retry(2, delay: 1, scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.favedMeIsLoading = false
            }, receiveValue: { value in
                defer {
                    let isLimitReached = self.pageSize != value.users.count
                    let isTechnicalLimitReached = self.favedMePeople.count + self.pageSize >= self.technicalLimit
                    self.canLoadMoreFaves = !isLimitReached && !isTechnicalLimitReached
                }
                if refresh {
                    self.favedMePeople = Array(value.users)
                    self.handleProfileToOpenFromNotification(tabType: .favedMe)
                } else {
                    self.favedMePeople.append(contentsOf: value.users)
                }
                log("refresh=\(refresh) favedMePeople=\(self.favedMePeople.count)")
            })
            .store(in: &cancellables)
    }
    
    func loadLikededMePeople(refresh: Bool = false) {
        guard refresh || canLoadMoreLikes, !likedMeIsLoading else { return }
        likedMeIsLoading = true
        let excludedIds = refresh ? [] : likedMePeople.map { $0.id }
        
        let query = GetNotificationsQuery(first: pageSize, notificationType: .likedMe,
                                          excludedIds: excludedIds)
        HTTPClient.shared.request(query: query, waitsForConnectivity: true)
            .retry(2, delay: 1, scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.likedMeIsLoading = false
            }, receiveValue: { value in
                defer {
                    let isLimitReached = self.pageSize != value.users.count
                    let isTechnicalLimitReached = self.likedMePeople.count + self.pageSize >= self.technicalLimit
                    self.canLoadMoreLikes = !isLimitReached && !isTechnicalLimitReached
                }
                if refresh {
                    self.likedMePeople = Array(value.users)
                    self.handleProfileToOpenFromNotification(tabType: .likedMe)
                } else {
                    self.likedMePeople.append(contentsOf: value.users)
                }
                log("refresh=\(refresh) likedMePeople=\(self.likedMePeople.count)")
            })
            .store(in: &cancellables)
    }
    
    func updateNewNotificationsCount(tab: NotificationTab, profile: ProfileDTO ) {
        markNotificationsAsViewed(tab: tab, profile: profile)
        switch tab {
        case .likedMe:
            if profile.hasNewLike {
                myProfileService.myProfile?.updateLikedMeCount(changes: -1)
            }
        case .viewedMe:
            if profile.hasNewVisit {
                myProfileService.myProfile?.updateViewedMeCount(changes: -1)
            }
        case .favedMe:
            if profile.hasNewFave{
                myProfileService.myProfile?.updateFavedMeCount(changes: -1)
            }
        }
    }
    
    private func markNotificationsAsViewed(tab: NotificationTab, profile: ProfileDTO) {
        let query = MarkNotificationsAsViewedQuery(request: .init(types: [tab.type], userIds: [profile.id]))
        HTTPClient.shared.request(query: query, waitsForConnectivity: true)
            .retry(2, delay: 1, scheduler: DispatchQueue.main)
            .replaceError(with: MarkNotificationsAsViewedQuery.Response(data: nil))
            .sink { value in
                if let errorMessage = value.errorMessage {
                    loge("\(errorMessage)")
                }
            }
            .store(in: &cancellables)
        
        switch tab {
        case .likedMe:
            if let index = likedMePeople.firstIndex(where: { $0.id == profile.id }) {
                likedMePeople[index].resetNewLike()
            }
        case .viewedMe:
            if let index = viewedMePeople.firstIndex(where: { $0.id == profile.id }) {
                viewedMePeople[index].resetNewVisit()
            }
        case .favedMe:
            if let index = favedMePeople.firstIndex(where: { $0.id == profile.id }) {
                favedMePeople[index].resetNewFave()
            }
        }
    }
    
    // MARK: - Web Sockets Transport & APNs Transport
    
    private func observeIncomingMessages() {
        socketClient.observe(for: .viewed) { data in
            self.onSocketViewsNotifications(data)
        }
        socketClient.observe(for: .liked) { data in
            self.onSocketLikesNotifications(data)
        }
        socketClient.observe(for: .faved) { data in
            self.onSocketFavesNotifications(data)
        }
        
        apnsClient.observe(for: [.groupProfile]) { _, _, data in
            self.onSocketOrAPNsNotification(data, tabType: .viewedMe)
        }
        apnsClient.observe(for: [.groupLikeFavorite, .groupLikeWinkFavorite,
                                 .groupWinkFavorite, .groupFavorite]) { _, _, data in
                                     self.onSocketOrAPNsNotification(data, tabType: .favedMe)
                                 }
        apnsClient.observe(for: [.groupLike]) { _, _, data in
            self.onSocketOrAPNsNotification(data, tabType: .likedMe)
        }
    }
    
    private func onSocketViewsNotifications(_ viewsDict: [String: Any]) {
        guard let notificationInfo = NotificationInfo(viewsDict, type: .viewedProfile) else { return }
        myProfileService.myProfile?.updateViewedMeCount(changes: 1)
        self.reloadTab(tabType: .viewedMe)
        homePresenter.show(notification: notificationInfo) {
            self.onSocketOrAPNsNotification(viewsDict, tabType: .viewedMe)
        }
    }
    
    private func onSocketLikesNotifications(_ viewsDict: [String: Any]) {
        guard let notificationInfo = NotificationInfo(viewsDict, type: .photoLike) else { return }
        myProfileService.myProfile?.updateLikedMeCount(changes: 1)
        self.reloadTab(tabType: .likedMe)
        homePresenter.show(notification: notificationInfo) {
            self.onSocketOrAPNsNotification(viewsDict, tabType: .likedMe)
        }
    }
    
    private func onSocketFavesNotifications(_ viewsDict: [String: Any]) {
        guard let notificationInfo = NotificationInfo(viewsDict, type: .favedProfile) else { return }
        myProfileService.myProfile?.updateFavedMeCount(changes: 1)
        self.reloadTab(tabType: .favedMe)
        homePresenter.show(notification: notificationInfo) {
            self.onSocketOrAPNsNotification(viewsDict, tabType: .favedMe)
        }
    }
    
    private func onSocketOrAPNsNotification(_ viewsDict: [String: Any], tabType: NotificationTab) {
        guard myProfileService.myProfile != nil && homeRouter.navigationController != nil else {
            return DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.onSocketOrAPNsNotification(viewsDict, tabType: tabType)
            }
        }
        guard let senderId = viewsDict["fromGlobalId"] as? ID else {
            return
        }
        if myProfileService.isVip {
            profileToOpenFromNotification = senderId
            homeRouter.popToRoot()
            homeRouter.dissmisToRoot()
            homeRouter.openTab = .notifications
            notificationsRouter.open(tab: tabType)
            handleProfileToOpenFromNotification(tabType: tabType)
        } else {
            subscriptionsPresenter.showPaywall(page: .seeWhoInterested,
                                               reason: .pushPromo,
                                               onSucceded: {
                self.onSocketOrAPNsNotification(viewsDict, tabType: tabType)
            })
        }
    }
    
    private func handleProfileToOpenFromNotification(tabType: NotificationTab) {
        var arrayForOpen: [ProfileDTO] = []
        switch tabType {
        case .likedMe:
            arrayForOpen = likedMePeople
        case .viewedMe:
            arrayForOpen = viewedMePeople
        case .favedMe:
            arrayForOpen = favedMePeople
        }
        guard let profileIdToOpen = profileToOpenFromNotification else { return }
        guard let profileToTopen = arrayForOpen.first(where: { $0.id == profileIdToOpen }) else {
            self.reloadTab(tabType: tabType)
            return
        }
        let profileView = AnyView(UserProfileView(profile: profileToTopen,
                                                  openFrom: .tab(.notifications),
                                                  onBackClicked: { self.homeRouter.pop() }))
        let chatView = AnyView(ChatView(chat: profileToTopen,
                                        openFrom: .userProfile,
                                        onBackClicked: { self.homeRouter.pop() }))
        self.updateNewNotificationsCount(tab: tabType, profile: profileToTopen)
        homeRouter.push(views: [profileView, chatView])
        
        profileToOpenFromNotification = nil
    }
    
    func reset() {
        likedMeIsLoading = false
        viewedMeIsLoading = false
        favedMeIsLoading = false
        canLoadMoreFaves = true
        canLoadMoreLikes = true
        canLoadMoreViews = true
        viewedMePeople = []
        likedMePeople = []
        favedMePeople = []
    }
}
