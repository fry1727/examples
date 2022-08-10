//
//  NotificationViewFooter.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 10.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import UIKit

class NotificationsFooter: UICollectionReusableView {
    static let identfier = "NotificationsFooter"

    let inidicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(inidicator)
        inidicator.startAnimating()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        inidicator.center = CGPoint(x: frame.width / 2, y: frame.height / 3)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
}
