//
//  QuickReplyViewModel.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 13.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

final class QuickReplyViewModel: ObservableObject {
    @Published var quickReply: QuickReplyDTO
    @Published var quickReplies: [QuickReplyDTO]
    @Published var myProfileService = MyProfileService.shared

    init() {
        quickReply = (AppConfigService.shared.config?.autoReplies ?? [])
            .randomElement() ?? QuickReplyDTO(id: "", message: "")
        quickReplies = AppConfigService.shared.config?.autoReplies?.shuffled() ?? []
    }

    func repliesForSettings() -> [QuickReplyDTO] {
        var replyList: [QuickReplyDTO] = []
        for reply in quickReplies {
            if reply.id == myProfileService.myProfile?.autoreply ?? "" {
                replyList.append(reply)
            }
        }
        for reply in quickReplies {
            if reply.id != myProfileService.myProfile?.autoreply ?? ""
                && replyList.count < 3 {
                replyList.append(reply)
            }
        }
        return replyList
    }

    func saveQuickReply(id: String) {
        self.myProfileService.myProfile?.autoreply = id
        updateQuickReplyProfile(quickReplyID: id) { _ in
        }
    }

    private func updateQuickReplyProfile(quickReplyID: String, completion: @escaping (Bool) -> Void) {
        HTTPClient.shared.request(query: UpdateQuickReplyQuery(request: .init(autoreply: quickReplyID))) { result in
            switch result {
            case let .success(response):
                if response.profile != nil {
                    completion(true)
                }
            case let .failure(error):
                loge(error)
            }
        }
    }
}
