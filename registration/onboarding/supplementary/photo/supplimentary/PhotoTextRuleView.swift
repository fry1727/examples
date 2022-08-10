//
//  RegistationPhotoTextRuleView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct PhotoTextRuleView: View {
    let text: String
    let type: PhotoRuleType

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(type.color)
                .cornerRadius(8)

            Text(text)
                .style(.mediumBodyRegular)
                .foregroundColor(Color(.bodyTextIcons))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
        }
        .frame(
            width: UIScreen.screenWidth * 0.914,
            height: 36
        )
        .clipped()
    }
}

struct RegistationPhotoRuleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            PhotoTextRuleView(text: L10n.uploadClearPhotoShowingYourFace, type: .accepted)
            PhotoTextRuleView(text: L10n.nudityOrPornographyAreProhibited, type: .declined)
        }
    }
}
