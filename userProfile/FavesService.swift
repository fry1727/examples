//
//  FavesService.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 8.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation
import Combine

final class FavesService: ObservableObject {
    static let shared = FavesService()
    private var cancellables: [AnyCancellable] = []
    private var favedProfilesDict: [ID: Bool] = [:]
    
    private init() {}
    
    func isUserFaved(_ user: ProfileDTO) -> Bool {
        if favedProfilesDict.keys.contains(user.id) {
            return favedProfilesDict[user.id] ?? false
        }
        return user.faved
    }
    
    func addFavorite(user: ProfileDTO) {
        let query = AddFavoritesQuery(request: .init(userId: user.id))
        HTTPClient.shared.request(query: query, waitsForConnectivity: true)
            .retry(2, delay: 1, scheduler: DispatchQueue.main)
            .replaceError(with: AddFavoritesQuery.Response(data: nil))
            .sink { value in
                if let errorMessage = value.errorMessage {
                    loge("\(errorMessage)")
                } else {
                    self.favedProfilesDict[user.id] = true
                }
            }
            .store(in: &cancellables)
    }
    
    func removeFavorite(user: ProfileDTO) {
        let query = RemoveFavoritesQuery(request: .init(userId: user.id))
        HTTPClient.shared.request(query: query, waitsForConnectivity: true)
            .retry(2, delay: 1, scheduler: DispatchQueue.main)
            .replaceError(with: RemoveFavoritesQuery.Response(data: nil))
            .sink { value in
                if let errorMessage = value.errorMessage {
                    loge("\(errorMessage)")
                } else {
                    self.favedProfilesDict[user.id] = false
                }
            }
            .store(in: &cancellables)
    }
}
