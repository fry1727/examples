//
//  StarIconView.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 7.06.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct FaveButton: View {
    @Binding var isFaved: Bool
    @State private var scale = 1.0
    
    var body: some View {
        Button{
            withAnimation() {
                isFaved.toggle()
                if isFaved {
                    scale = 1.4
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        scale = 1.0
                    }
                }
            }
        } label: {
            Image(isFaved == true ? "faveFilled" : "faveEmpty")
                .foregroundColor(.getColor(isFaved == true ? .gold : .inactiveItemTextIcons))
                .frame(width: 18, height: 17, alignment: .leading)
                .padding(4)
                .animation(.easeInOut)
                .scaleEffect(scale)
        }
    }
}

#if DEBUG
struct StarIconView_Previews: PreviewProvider {
    static var previews: some View {
        FaveButton(isFaved: .constant(true))
    }
}
#endif
