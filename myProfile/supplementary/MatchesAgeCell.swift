//
//  MatchesAgeRow.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 28.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct MatchesAgeCell: View {
    let profile: ProfileDTO

    @State private var matchesAge: ClosedRange<Int>

    init(profile: ProfileDTO) {
        self.profile = profile
        let seekingAgeFrom = profile.seekingAgeFrom ?? ageRange.lowerBound
        let seekingAgeTo = profile.seekingAgeTo ?? ageRange.upperBound
        self._matchesAge = State(initialValue: seekingAgeFrom...seekingAgeTo)
    }

    var body: some View {
        HStack(spacing: 0) {
            Image("setting-search")
                .frame(width: 32, height: 32)
                .background(Color(.border))
                .cornerRadius(4)

            Spacer()

            VStack(spacing: 0) {
                Text("Matches age preferences")
                    .style(.smallBodyRegular)
                    .foregroundColor(Color(.subheadText))
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 8) {
                    TwoSidedSlider(value: $matchesAge, range: ageRange)
                        .frame(width: UIScreen.screenWidth - 170)

                    Group {
                        if matchesAge.lowerBound == matchesAge.upperBound {
                            Text("\(matchesAge.lowerBound)")
                        } else {
                            Text("\(matchesAge.lowerBound)-\(matchesAge.upperBound)")
                        }
                    }
                    .foregroundColor(.white)
                    .style(.mediumBody)
                    .frame(width: 80, height: 28)
                    .background(Color(.primary))
                    .cornerRadius(4)
                    .padding(.trailing, 8)
                }
            }
        }
        .onDisappear {
            if matchesAge.lowerBound != profile.seekingAgeFrom ||
                matchesAge.upperBound != profile.seekingAgeTo {
                saveChanges()
            }
        }
    }

    private func saveChanges() {
        let query = UpdateSeekingAge(request: .init(seekingAgeFrom: matchesAge.lowerBound,
                                                    seekingAgeTo: matchesAge.upperBound))
        HTTPClient.shared.request(query: query) { result in
            if case let .failure(error) = result {
                loge(error.localizedDescription)
            } else {
                var profile = self.profile
                profile.seekingAgeFrom = matchesAge.lowerBound
                profile.seekingAgeTo = matchesAge.upperBound
                MyProfileService.shared.myProfile = profile
            }
        }
    }
}
