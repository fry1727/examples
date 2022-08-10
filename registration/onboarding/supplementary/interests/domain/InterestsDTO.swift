//
//  InterestsDTO.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 20.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct Interests: Codable, Hashable {
    let id: ID
    let title: String
    let type: String
}

struct InterestModel: Hashable {
    let id: String
    let interest: String
}
