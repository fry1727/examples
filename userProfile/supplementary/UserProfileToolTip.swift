//
//  UserProfileToolTip.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 8.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct UserProfileToolTip: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .foregroundColor(.white)
                .style(.mediumBodyRegular)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .background(background)
        .padding(.horizontal, 16)
        .padding(.bottom, 7)
    }
    
    private var background: some View {
        let notch = Rectangle()
            .fill(Color(.primary))
            .frame(width: 14, height: 14)
            .rotationEffect(.degrees(45))
        return RoundedRectangle(cornerRadius: 13)
            .fill(Color(.primary))
            .overlay(notch.offset(x: -45, y: -3), alignment: .topTrailing)
    }
}

struct UserProfileToolTip_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileToolTip(message: "⭐️ Tap the star to fave user")
    }
}

