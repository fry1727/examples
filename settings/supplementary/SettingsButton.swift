//
//  SettingsButton.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 7.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct SettingsButton: View {
    @State var buttonText: String
    @State var buttonAction: () -> Void

    var body: some View {
        Button {
            buttonAction()
        } label: {
            HStack {
                Text(buttonText)
                    .style(.largeBodyRegular)
                    .foregroundColor(.getColor(.bodyTextIcons))
                Spacer()
                Image("shevronRight")
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(Color.getColor(.background))
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton(buttonText: "Contact Us", buttonAction: {})
    }
}
