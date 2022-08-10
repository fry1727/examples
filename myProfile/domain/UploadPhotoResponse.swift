//
//  UploadPhotoResponse.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 10.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct UploadPhotoResponse: Codable {
    let photoId: String?
    let smallUrl: String?
    let bigUrl: String?
    let errors: [ErrorDTO]?
}
