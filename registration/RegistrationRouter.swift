//
//  RegistrationRouter.swift
//  Meetville
//
//  Created by Egor Yanukovich on 9.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

final class RegistrationRouter: BaseRouter, BasePresenter {
    weak var navigationController: UINavigationController?

    init(navController: UINavigationController? = nil) {
        navigationController = navController
    }

    func swipeToBack(_ enabled: Bool) {
        guard let navController = navigationController as? NavigationController else { return }
        navController.isSwipeToBackEnabled = enabled
    }

    func setRootNavigation<V: View>(views: [V], animated: Bool = true) {
        let controllers = views.compactMap { UIHostingController(rootView: $0) }
        navigationController?.setViewControllers(controllers, animated: animated)
    }
}
