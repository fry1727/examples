//
//  CityPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 24.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct CityPage: View {
    let onSelected: (CityDTO) -> Void

    let homeRouter = HomeRouter.shared
    @ObservedObject var viewModel = EditProfileViewModel()
    @State private var newCity: CityDTO?
    @State private var showSkeletonLoading = false

    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.isLoadingCities {
                    if !viewModel.citiesList.isEmpty {
                        List {
                            ForEach(viewModel.citiesList, id: \.id) { city in
                                Button {
                                    newCity = city
                                } label: {
                                    buttonLabel(city: city)
                                }
                            }
                        }
                    } else {
                        Text("Sorry, this city is not found.")
                            .foregroundColor(Color(.bodyTextIcons))
                            .style(.mediumBodyRegular)
                            .padding(16)
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                } else if showSkeletonLoading {
                    List {
                        ForEach(0...20, id: \.self) { city in
                            Text(String.placeholder(length: Int.random(in: 8...15)))
                                .redacted(reason: .placeholder)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarSearch($viewModel.searchText)
            .navigation(title: L10n.city,
                        onBackClicked: { homeRouter.pop() })
            .onAppear {
                withDelay(.milliseconds(100)) {
                    showSkeletonLoading = true
                }
            }
            .onDisappear {
                saveChanges()
            }
        }
        .navigationViewStyle(.stack)
    }

    private func buttonLabel(city: CityDTO) -> some View {
        return HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name ?? "")
                    .foregroundColor(.getColor(.bodyTextIcons))
                    .setTextStyle(.largeBodyRegular)
                Text("\(city.countryName ?? ""), \(city.countryCode ?? "")")
                    .foregroundColor(.getColor(.subheadText))
                    .setTextStyle(.smallBodyRegular)
            }
            Spacer()
            if city.id == newCity?.id {
                Image("check_circle")
            }
        }
    }

    private func saveChanges() {
        if let newCity = newCity {
            onSelected(newCity)
        }
    }
}

struct CityPage_Previews: PreviewProvider {
    static var previews: some View {
        CityPage(onSelected: { _ in })
    }
}
