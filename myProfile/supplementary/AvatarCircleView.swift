//
//  AvatarCircleView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 22.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct AvatarCircleView: View {
    let imageUrl: String?
    let sex: SexEnum?

    var body: some View {
        if imageUrl != nil {
            AsyncImage(url: imageUrl ?? "")
                .frame(width: 140, height: 140)
                .clipShape(Circle())
        } else {
            DefaultImage(sex: sex)
                .frame(width: 140, height: 140)
                .clipShape(Circle())
        }
    }
}

struct AvatarCircleView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarCircleView(imageUrl: "", sex: .male)
    }
}
