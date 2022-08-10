//
//  ViewerRelatedService.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 20.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation
import Combine

final class UserProfileService: ObservableObject {
    static let shared = UserProfileService()
    private var cancellables: [AnyCancellable] = []
    
    private init() {}
    
    func viewProfile(userID: String) {
        let query = ViewProfileQuery(request: .init(userId: userID))
        HTTPClient.shared.request(query: query, waitsForConnectivity: true)
            .retry(2, delay: 1, scheduler: DispatchQueue.main)
            .replaceError(with: ViewProfileQuery.Response(data: nil))
            .sink { value in
                if let errorMessage = value.errorMessage {
                    loge("\(errorMessage)")
                }
            }
            .store(in: &cancellables)
    }
    
    func wantsChat(userID: String) {
        let query = WantsChatQuery(request: .init(userId: userID))
        HTTPClient.shared.request(query: query, waitsForConnectivity: true)
            .retry(2, delay: 1, scheduler: DispatchQueue.main)
            .replaceError(with: WantsChatQuery.Response(data: nil))
            .sink { value in
                if let errorMessage = value.errorMessage {
                    loge("\(errorMessage)")
                }
            }
            .store(in: &cancellables)
    }
}
