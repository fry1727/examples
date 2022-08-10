//
//  ToastAlert.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 1.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct ToastAlert: ViewModifier {
    let message: String
    @Binding var isShowing: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            toastView
        }
    }

    private var toastView: some View {
        VStack {
            Spacer()
            if isShowing {
                Group {
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.getColor(.textIconsOnBack))
                        .setTextStyle(.mediumBodyRegular)
                        .padding(18)
                        .frame(maxWidth: .infinity)
                }
                .background(Color.getColor(.primary))
                .frame(height: 56)
                .cornerRadius(13)
                .onTapGesture {
                    isShowing = false
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isShowing = false
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .animation(.linear(duration: 0.3), value: isShowing)
        .transition(.opacity)
    }
}

extension View {
    func toast(message: String,
               isShowing: Binding<Bool>) -> some View
    {
        modifier(ToastAlert(message: message,
                            isShowing: isShowing))
    }
}
