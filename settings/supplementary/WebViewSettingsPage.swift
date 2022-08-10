//
//  WebViewSettingsPage.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 7.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI
import WebKit

struct WebViewSettingsPage: View {
    let url: URL
    let header: String

    let homeRouter = HomeRouter.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                WebView(url: url)
            }
            .navigation(title: header, onBackClicked: {
                homeRouter.pop()
            })
        }
        .navigationViewStyle(.stack)
    }
}

struct TermsOfUsePage_Previews: PreviewProvider {
    static var previews: some View {
        WebViewSettingsPage(url: URL(string: "")!, header: "")
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context _: Context) -> some UIView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}
