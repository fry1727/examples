//
//  AboutMePage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 24.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI

struct AboutMeView: View {
    @State private var text: String
    let onBackClicked: () -> Void

    @ObservedObject var viewModel = EditProfileViewModel()
    @State var placeholder = "Tell people how amazing are you"
    private var initialText: String

    init(text: String, onBackClicked: @escaping () -> Void) {
        self._text = State(initialValue: text)
        self.onBackClicked = onBackClicked
        initialText = text
    }

    var body: some View {
        NavigationView {
            ZStack {
                if text.isEmpty {
                    TextEditor(text: $placeholder)
                        .setTextStyle(.largeBodyRegular)
                        .foregroundColor(.getColor(.placeholderFilledText))
                }
                FirstResponderTextView(text: $text, isFirstResponder: true)
                    .opacity(text.isEmpty ? 0.25 : 1)
                    .onChange(of: text, perform: { value in
                        if value.count > 300 {
                            text = String(value.prefix(300))
                        }
                    })
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .navigation(title: L10n.aboutMe, onBackClicked: onBackClicked,
                        trailing: trailingView)
        }
        .navigationViewStyle(.stack)
        .onDisappear {
            if text != initialText {
                saveChanges()
            }
        }
    }

    private var trailingView: some View {
        Text("\(text.count)/300")
            .foregroundColor(.getColor(.placeholderText))
            .setTextStyle(.mediumBodyRegular)
    }

    private func saveChanges() {
        viewModel.aboutMeSaveButtonPressed(text: text)
    }
}

struct AboutMePage_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeView(text: "", onBackClicked: {})
    }
}
