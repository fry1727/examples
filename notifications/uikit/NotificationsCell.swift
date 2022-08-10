//
//  NotificationViewCell.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 5.05.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Kingfisher
import SwiftUI
import UIKit

final class NotificationsCell: UICollectionViewCell {
    static let identfier = "NotificationsCell"
    private var profile: ProfileDTO?
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.getColor(.inactiveItem)
        return imageView
    }()
    
    lazy var blurOverlay: UIVisualEffectView = {
        var blurEffect: UIBlurEffect
        blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 1
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurredEffectView
    }()
    
    let imageGradientBottom: GradientView = {
        let gradientView = GradientView(frame: .zero)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.clipsToBounds = true
        return gradientView
    }()
    
    let imageGradientTop: GradientViewTop = {
        let gradientView = GradientViewTop(frame: .zero)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.clipsToBounds = true
        return gradientView
    }()
    
    let profileTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = TextStyle.mediumBodyRegular.font
        label.numberOfLines = 1
        return label
    }()
    
    let profileStatus: UIView = {
        let circleView = CircleView(frame: .zero)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        return circleView
    }()

    let newLabel: NewLabel = {
        let newLabel = NewLabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        return newLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImage)
        
        profileImage.addSubview(blurOverlay)
        profileImage.addSubview(profileStatus)
        profileImage.addSubview(imageGradientTop)
        profileImage.addSubview(imageGradientBottom)
        profileImage.addSubview(profileTitle)
        profileImage.addSubview(profileStatus)
        profileImage.addSubview(newLabel)

        NSLayoutConstraint.activate([
            profileImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            profileImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageGradientTop.leftAnchor.constraint(equalTo: profileImage.leftAnchor),
            imageGradientTop.rightAnchor.constraint(equalTo: profileImage.rightAnchor),
            imageGradientTop.topAnchor.constraint(equalTo: profileImage.topAnchor),
            imageGradientTop.heightAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 0.2),

            newLabel.rightAnchor.constraint(equalTo: imageGradientTop.rightAnchor, constant: -8),
            newLabel.topAnchor.constraint(equalTo: imageGradientTop.topAnchor, constant: 8),
            newLabel.heightAnchor.constraint(equalToConstant: 18),
            newLabel.widthAnchor.constraint(equalToConstant: 42),

            imageGradientBottom.leftAnchor.constraint(equalTo: profileImage.leftAnchor),
            imageGradientBottom.rightAnchor.constraint(equalTo: profileImage.rightAnchor),
            imageGradientBottom.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
            imageGradientBottom.heightAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 0.5),
            
            profileTitle.leftAnchor.constraint(equalTo: profileImage.leftAnchor, constant: 12),
            profileTitle.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -8),
            
            profileStatus.leftAnchor.constraint(equalTo: profileTitle.rightAnchor, constant: 8),
            profileStatus.rightAnchor.constraint(lessThanOrEqualTo: profileImage.rightAnchor, constant: -8),
            profileStatus.centerYAnchor.constraint(equalTo: profileTitle.centerYAnchor),
            profileStatus.widthAnchor.constraint(equalToConstant: 8),
            profileStatus.heightAnchor.constraint(equalToConstant: 8),
        ])
        
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 14
        layer.masksToBounds = false
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.alpha = self.isHighlighted ? 0.9 : 1.0
                self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                CGAffineTransform.identity
            })
        }
    }
    
    func configure(with profile: ProfileDTO, isBlured: Bool, isNew: Bool) {
        self.profile = profile
        profileTitle.text = isBlured ? profile.online?.content : profile.fullName
        blurOverlay.isHidden = !isBlured
        imageGradientTop.isHidden = isBlured
        imageGradientBottom.isHidden = isBlured
        profileStatus.backgroundColor = profile.onlineStatusColor
        newLabel.isHidden = !isNew
        
        if let urlString = profile.mainPhotoPreview, let url = URL(string: urlString) {
            profileImage.kf.indicatorType = .custom(indicator: ActivityIndicator())
            profileImage.kf.setImage(with: url, options: [
                .transition(.fade(0.4)),
            ])
        } else {
            profileImage.image = UIImage(sex: profile.sex)
        }
    }
}
