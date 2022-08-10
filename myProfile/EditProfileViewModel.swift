//
//  EditProfileViewModel.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 22.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Combine
import SwiftUI

class EditProfileViewModel: ObservableObject {
    @ObservedObject var myProfileService = MyProfileService.shared
    @Published var citiesList: [CityDTO] = []
    @Published var isLoadingCities = false
    @Published var searchText: String = ""
    var cancellable = [AnyCancellable]()

    init() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { _ in
            } receiveValue: { [self] _ in
                getCityList(input: searchText)
            }.store(in: &cancellable)
    }

    private func getCityList(input: String) {
        isLoadingCities = true
        HTTPClient.shared.request(query: FindCityQuery(input: input)) { result in
            self.isLoadingCities = false
            switch result {
            case let .success(response):
                if let cities = response.cities {
                    self.citiesList = cities
                }
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    private func updateOwnWordsProfile(newOwnWords: String, completion: @escaping (Bool) -> Void) {
        HTTPClient.shared.request(query: UpdateOwnWordsQuery(request: .init(ownWords: newOwnWords))) { result in
            switch result {
            case let .success(response):
                if response.profile != nil {
                    completion(true)
                }
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }

    private func updateCityProfile(cityId: String, completion: @escaping (Bool) -> Void) {
        HTTPClient.shared.request(query: UpdateCityQuery(request: .init(cityId: cityId))) { result in
            switch result {
            case let .success(response):
                if response.profile != nil {
                    completion(true)
                }
            case let .failure(error):
                log("error: \(error.localizedDescription)")
            }
        }
    }

    func citySaveButtonPressed(city: CityDTO) {
        updateCityProfile(cityId: city.id ?? "") { _ in
            self.myProfileService.myProfile?.city = city
        }
    }

    func aboutMeSaveButtonPressed(text: String) {
        let text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        updateOwnWordsProfile(newOwnWords: text) { _ in
            self.myProfileService.myProfile?.ownWords = text
        }
    }
}
