//
//  UnlockButton.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 10.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct UnlockButton: View {
    let action: () -> Void
    let text: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                Color.Gradients.clearTopWhiteBottomGradient
                    .opacity(0.7)
                LargeButton(text: text,
                            textStyle: .largeBoldUpperCase,
                            action: { action() })
                .padding(.bottom, 32)
            }
            .frame(height: 100)
        }
    }
}

struct UnlockButton_Previews: PreviewProvider {
    static var previews: some View {
        UnlockButton(action: {}, text: "text")
    }
}
