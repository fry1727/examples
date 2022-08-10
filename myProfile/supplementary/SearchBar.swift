//
//  SearchBar.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 24.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Combine
import SwiftUI

struct SearchBarNew: UIViewControllerRepresentable {
    @Binding var text: String

    init(text: Binding<String>) {
        _text = text
    }

    func makeUIViewController(context _: Context) -> SearchBarWrapperController {
        return SearchBarWrapperController()
    }

    func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
        controller.searchController = context.coordinator.searchController
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UISearchResultsUpdating {
        @Binding var text: String
        let searchController: UISearchController

        private var subscription: AnyCancellable?

        init(text: Binding<String>) {
            _text = text
            searchController = UISearchController(searchResultsController: nil)
            super.init()
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.text = self.text
            subscription = self.text.publisher.sink { _ in
                self.searchController.searchBar.text = self.text
            }
        }

        deinit {
            self.subscription?.cancel()
        }

        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            self.text = text
        }
    }

    class SearchBarWrapperController: UIViewController {
        var searchController: UISearchController? {
            didSet {
                self.parent?.navigationItem.hidesSearchBarWhenScrolling = false
                self.parent?.navigationItem.searchController = searchController
            }
        }

        override func viewWillAppear(_: Bool) {
            parent?.navigationItem.searchController = searchController
        }

        override func viewDidAppear(_: Bool) {
            parent?.navigationItem.searchController = searchController
        }
    }
}

public extension View {
    func navigationBarSearch(_ searchText: Binding<String>) -> some View {
        return overlay(SearchBarNew(text: searchText).frame(width: 0, height: 0))
    }
}
