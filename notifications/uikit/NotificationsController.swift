//
//  NotificationViewController.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 5.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

struct NotificationsControllerView: UIViewControllerRepresentable {
    var notificationType: NotificationTab

    func makeUIViewController(context _: Context) -> NotificationsController {
        NotificationsController(notificationType: notificationType)
    }

    func updateUIViewController(_: NotificationsController, context _: Context) {}
}

final class NotificationsController: UIViewController {
    let notificationTab: NotificationTab

    private var notificationsProfiles: [ProfileDTO] = []
    private let myProfileService = MyProfileService.shared
    private let homeRouter = HomeRouter.shared
    private let notificationService = NotificationsService.shared
    private let subscriptionsPresenter = SubscriptionsPresenter.shared
    private var cancellables = Set<AnyCancellable>()

    init(notificationType: NotificationTab) {
        self.notificationTab = notificationType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let inset = 8.0
        let spacing = 7.0
        let width = (view.frame.size.width - 2 * inset - spacing) / 2
        let height = width * 160 / 167.0 + 40
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = TouchingCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(NotificationsCell.self,
                                forCellWithReuseIdentifier: NotificationsCell.identfier)
        collectionView.register(NotificationsFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NotificationsFooter.identfier)
        collectionView.register(NotificationsHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NotificationsHeader.identfier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl.addTarget(self, action: #selector(onRefreshRequested), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveNotification(notification:)),
                                               name: .scrollTabToTopNotification, object: nil)

        notificationTab.dataSource
            .receive(on: DispatchQueue.main)
            .sink { profiles in
                self.notificationsProfiles = profiles
                self.collectionView.reloadData()
            }.store(in: &cancellables)

        notificationTab.dataStatus
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if !isLoading, self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }.store(in: &cancellables)

        myProfileService.$myProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }.store(in: &cancellables)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let bottomOffset = collectionView.contentSize.height - collectionView.frame.size.height
        if position > 0, position > bottomOffset - view.height * 3 {
            switch notificationTab {
            case .viewedMe:
                notificationService.loadViewedMePeople()
            case .favedMe:
                notificationService.loadFavedMePeople()
            case .likedMe:
                notificationService.loadLikededMePeople()
            }
        }
    }

    @objc func onRefreshRequested() {
        switch notificationTab {
        case .viewedMe:
            notificationService.loadViewedMePeople(refresh: true)
        case .favedMe:
            notificationService.loadFavedMePeople(refresh: true)
        case .likedMe:
            notificationService.loadLikededMePeople(refresh: true)
        }
    }

    @objc func onReceiveNotification(notification: Notification) {
        if notification.name == .scrollTabToTopNotification,
           (notification.object as? HomeTab) == .notifications
        {
            collectionView.setContentOffset(.zero, animated: true)
        }
    }
}

extension NotificationsController: UICollectionViewDelegate, UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout
{
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        notificationsProfiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationsCell.identfier,
                                                            for: indexPath) as? NotificationsCell
        else {
            return UICollectionViewCell()
        }
        let profile = notificationsProfiles[indexPath.row]
        let isBlured = !(myProfileService.myProfile?.isVip ?? true)
        let hasNotifications = hasNotifications(for: profile)

        cell.configure(with: profile, isBlured: isBlured, isNew: hasNotifications)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NotificationsHeader.identfier, for: indexPath)
            return headerView

        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NotificationsFooter.identfier, for: indexPath)
            return footerView
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: myProfileService.isVip ? 0 : 56)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection _: Int) -> CGSize {
        var canLoadMore = false
        switch notificationTab {
        case .viewedMe:
            canLoadMore = notificationService.canLoadMoreViews
        case .favedMe:
            canLoadMore = notificationService.canLoadMoreFaves
        case .likedMe:
            canLoadMore = notificationService.canLoadMoreLikes
        }
        return CGSize(width: view.frame.width,
                      height: canLoadMore ? 50 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let profile = notificationsProfiles[indexPath.row]
        if myProfileService.isVip {
            let userProfileView = UserProfileView(profile: profile,
                                                  openFrom: .tab(.notifications),
                                                  onBackClicked: { [weak self] in
                self?.homeRouter.pop()
            })
            notificationService.updateNewNotificationsCount(tab: notificationTab, profile: profile)
            homeRouter.push(view: userProfileView)
        } else {
            subscriptionsPresenter.showPaywall(page: .seeWhoInterested,
                                               reason: .notifications)
        }
    }

    func hasNotifications(for profile: ProfileDTO) -> Bool {
        switch notificationTab {
        case .likedMe:
            return profile.hasNewLike
        case .viewedMe:
            return profile.hasNewVisit
        case .favedMe:
           return profile.hasNewFave
        }
    }
}
