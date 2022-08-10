//
//  NotificationHeader.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 6.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import UIKit

class NotificationsHeader: UICollectionReusableView {
    static let identfier = "NotificationsHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.getColor(.subheadText)
        label.font = TextStyle.largeBodyMedium.font
        label.text = L10n.findOutWhoVisitedYourProfile
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        configure()
    }

    func configure() {
        addSubview(titleLabel)
        backgroundColor = .white
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8.0),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
}
