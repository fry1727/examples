//
//  UserProfileView.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 15.03.22.
//  Edited by Yauheni Skiruk on 21.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    let profile: ProfileDTO
    let openFrom: HomeRoute
    let onBackClicked: () -> Void
    @State private var isFaved: Bool
    
    private let homeRouter = HomeRouter.shared
    private let subscriptionsPresenter = SubscriptionsPresenter.shared
    private let chatsService = ChatsService.shared
    private let userProfileService = UserProfileService.shared
    private let favesService = FavesService.shared
    @StateObject var blockReportPresenter = BlockReportPresenter.shared
    @ObservedObject var blockReportService = BlockReportService.shared
    @State private var currentIndex = 0
    @State private var showTooltip = false
    @State private var showGallery = false

    init(profile: ProfileDTO, photoIndex: Int = 0,
         openFrom: HomeRoute, onBackClicked: @escaping () -> Void) {
        self.profile = profile
        self.openFrom = openFrom
        self.onBackClicked = onBackClicked
        _currentIndex = State(initialValue: photoIndex)
        self.isFaved = FavesService.shared.isUserFaved(profile)
    }

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Group {
                            if !profile.userProfilePhotos.isEmpty {
                                UserProfilePhotoCarousel(profilePhotos: profile.userProfilePhotos,
                                                         onPhotoClicked: { showGallery = true },
                                                         currentIndex: $currentIndex)
                                .id(showGallery)
                            } else {
                                DefaultImage(sex: profile.sex)
                            }
                        }
                        .frame(width: UIScreen.screenWidth - 32,
                               height: UIScreen.screenWidth * 1.2)
                        .padding([.top, .leading, .trailing], 16)
                        .padding(.bottom, UIScreen.isSmallDevice ? 4: 18)

                        UserProfileInfoView(profile: profile)
                            .padding(.top, 10)
                            .padding(.bottom, 100 + (UIScreen.screenSafeInsets?.bottom ?? 0))
                        Spacer()
                    }
                }

                if showTooltip {
                    toolTip
                        .transition(.scale.combined(with: .move(edge: .top)))
                }
                chatButtonSection
            }
            .fullScreenCover(isPresented: $showGallery) {
                UserProfileGallery(profilePhotos: profile.userProfilePhotos,
                                   currentIndex: $currentIndex,
                                   onBackClicked: { showGallery = false })
                .background(TrasnparentFullScreenCover())
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigation(title: ProfileHeaderView(profile: profile, style: .nameAge),
                        onBackClicked: onBackClicked,
                        trailingFirst: FaveButton(isFaved: $isFaved),
                        trailingSecond: moreButton)
            .message(text: blockReportPresenter.message,
                     bottomPadding: 23)
            .onChange(of: currentIndex) { newValue in
                NotificationCenter.default.post(name: .userProfilePhotoIndexChangedNotification,
                                                object: [profile.id : newValue])
            }
            .onChange(of: isFaved) { _ in
                    onFaveClicked(profile: profile)
            }
            .onTapGesture {
                blockReportPresenter.message = nil
                showTooltip = false
            }
            .onAppear {
                showToolTipIfNeeded()
                onProfileView()
            }
            .onDisappear {
                blockReportPresenter.message = nil
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var moreButton: some View {
        Button(action: { onMoreClicked() }) { Image("more") }
            .frame(width: 40, height: 40, alignment: .center)
    }
    
    private var chatButtonSection: some View {
        VStack(spacing: 0) {
            Spacer()
            if blockReportService.isUserBlocked(profile) {
                ZStack {
                    Color.white
                    ToolbarButton(title: L10n.unblock,
                                  action: { unblock(user: profile) })
                }
                .frame(height: 60 + (UIScreen.screenSafeInsets?.bottom ?? 0))
            } else {
                ZStack {
                    Color.Gradients.clearTopWhiteBottomGradient
                        .opacity(0.5)
                    Button(action: {
                        if !MyProfileService.shared.isVip &&
                            !profile.canSendMessage {
                            userProfileService.wantsChat(userID: profile.id)
                        }
                        open(chat: profile)
                    }, label: {
                        chatButtonLabel
                    })
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                }
                .frame(height: 100 + (UIScreen.screenSafeInsets?.bottom ?? 0))
            }
        }
    }
    
    private var chatButtonLabel: some View {
        return ZStack {
            Rectangle()
                .foregroundColor(.getColor(.secondary))
                .cornerRadius(16)
            HStack(spacing: 0) {
                Text(L10n.chat)
                    .foregroundColor(.getColor(.textIconsOnBack))
                    .setTextStyle(.largeBodyMedium)
                Image("chat_white")
                    .padding(.leading, 12)
            }
        }
    }
    
    private var toolTip: some View {
        VStack(){
            HStack{
                Spacer()
                UserProfileToolTip(message: "⭐️ Tap the star to fave user")
                    .padding(.top, 7)
                    .onTapGesture {
                        showTooltip = false
                    }
            }
            Spacer()
        }
    }
    
    private func open(chat _: ProfileDTO) {
        if case .tab(.chats) = openFrom {
            return onBackClicked()
        }
        let existingChat = chatsService.chats.first(where: { $0.id == profile.id })
        guard existingChat != nil ||
                MyProfileService.shared.isVip || profile.canSendMessage else {
            return showPaywall()
        }
        let chat = existingChat ?? profile
        let chatView = ChatView(chat: chat,
                                openFrom: .userProfile,
                                onBackClicked: { self.homeRouter.pop() })
        homeRouter.push(view: chatView)
    }
    
    private func showPaywall() {
        subscriptionsPresenter.showPaywall(page: .unlimitedMessages,
                                           reason: .chatProfile)
    }
    
    private func onMoreClicked() {
        UIApplication.shared.endEditing()
        blockReportPresenter.showBlockReportSheet(for: profile)
        showTooltip = false
    }
    
    private func onProfileView() {
        if !MyProfileService.shared.favedProfileTooltipShown {
            MyProfileService.shared.favedProfileTooltipShown = true
        }
        DispatchQueue.global().async {
            userProfileService.viewProfile(userID: profile.id)
        }
    }
    
    private func unblock(user _: ProfileDTO) {
        blockReportService.unblock(user: profile)
    }
    
    private func onFaveClicked(profile: ProfileDTO) {
            if favesService.isUserFaved(profile) {
                favesService.removeFavorite(user: profile)
            } else {
                favesService.addFavorite(user: profile)
            }
            showTooltip = false
    }

    private func showToolTipIfNeeded() {
        guard !MyProfileService.shared.favedProfileTooltipShown else {
            return
        }
        withDelay(.milliseconds(100)) {
            withAnimation(.spring()) {
                showTooltip = true
            }
        }
    }
}

#if DEBUG
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(profile: mockProfile, openFrom: .tab(.chats), onBackClicked: {})
            .previewDevice("iPhone 8")
    }
}
#endif

extension Notification.Name {
    static let userProfilePhotoIndexChangedNotification = Notification.Name("userProfilePhotoIndexChangedNotification")
}
