//
//  RegistationPhotoImageRuleView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 11.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct PhotoImageRuleView: View {
    let imageName: String
    let type: PhotoRuleType

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(imageName)
                .scaledToFill()
                .frame(width: 109, height: 109)

            Image(type.imageMark)
                .offset(y: 16)
                .frame(width: 32, height: 32)
        }
    }
}

struct PhotoImageRuleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            PhotoImageRuleView(imageName: "manRuleThree", type: .accepted)
            PhotoImageRuleView(imageName: "womanRuleThree", type: .declined)
        }
    }
}
