//
//  RegestrationPreferenceView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 10.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI


struct RegistrationPreferenceView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    @State private var selectedOption: RegestrationPreference = .manSeekingWoman

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.whoToYouPrefer)
                    .style(.largeTitle)

                Text(L10n.weJustNeedAFewThingsToStartSearching)
                    .style(.mediumBodyRegular)
                    .foregroundColor(Color(.subheadText))

                PrefereSelectableView(selectedOption: $selectedOption)
                    .padding(.top, 8)
                Spacer()
            }.padding(.horizontal, 24)
            LargeButton(type: .goOn) {
                viewModel.selectedPreference = self.selectedOption
                onNextClicked()
                AnalyticsService.logAmplitudeEvent(.stepPrefer(sex: selectedOption.sex,
                                                               seekingGender: selectedOption.lookingFor))
            }
            .padding(.bottom, 24)
        }
        .padding(.top, 78)
    }

    func onNextClicked() {
        once {
            viewModel.openNextPage()
            withAnimation {
                viewModel.progress += 1/5
            }
        }
    }
}

struct RegestrationPreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPreferenceView()
    }
}
