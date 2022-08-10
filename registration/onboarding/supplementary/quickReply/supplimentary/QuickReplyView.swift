//
//  QuickReplyView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 13.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct QuickReplyView: View {
    let quickReplyText: String
    var isSelected: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(isSelected ? "check_circle" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
            Text(quickReplyText)
                .foregroundColor(.black)
                .setTextStyle(.largeBodyRegular)
        }
        .padding(5)
    }
}

struct AutoreplyView_Previews: PreviewProvider {
    static var previews: some View {
        QuickReplyView(quickReplyText: "I currently have a lot of actions and I don't have the time to respond to all of them. If you send me a photo and a personal message I'll be able to decide if I'm interested. ", isSelected: false)
    }
}
