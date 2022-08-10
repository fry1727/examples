//
//  EditProfileRegularCell.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 28.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct EditProfileCell: View {
    let icon: String
    var iconTemplateMode = false
    let title: String
    let value: String
    let callback: () -> Void

    var body: some View {
        Button(action: callback) {
            HStack(spacing: 8) {
                if !iconTemplateMode {
                    Image(icon)
                        .frame(width: 32, height: 32)
                        .background(Color(.border))
                        .cornerRadius(4)
                } else {
                    Image(icon)
                        .renderingMode(.template)
                        .foregroundColor(Color(.bodyTextIcons))
                        .scaleEffect(0.4)
                        .frame(width: 32, height: 32)
                        .background(Color(.border))
                        .cornerRadius(4)
                }

                VStack(spacing: 6) {
                    Text(title)
                        .style(.smallBodyRegular)
                        .foregroundColor(Color(.subheadText))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(value)
                        .style(.largeBodyRegular)
                        .foregroundColor(Color(.bodyTextIcons))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)

                Spacer()

                Image(systemName: "chevron.forward")
                    .foregroundColor(.getColor(.bodyTextIcons))
            }
            .padding(.horizontal, 16)
        }
    }
}

struct EditProfileCell_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileCell(icon: "filter-city", title: "City", value: "London", callback: {})
    }
}
