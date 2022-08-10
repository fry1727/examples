//
//  TextFieldNamingView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct TextFieldNamingView: View {
    let text: String

    var body: some View {
        Text(text)
            .style(.smallBodyRegular)
            .foregroundColor(.getColor(.inactiveItemTextIcons))
            .padding([.leading], 16)
            .padding(.bottom, 8)
    }
}

struct TextFieldNamingView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldNamingView(text: "")
    }
}
