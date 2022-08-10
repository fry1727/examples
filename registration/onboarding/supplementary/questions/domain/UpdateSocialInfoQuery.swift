//
//  UpdateSocialInfoQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 15.07.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct UpdateIntentQuery: Query, MutatingQuery {
    var request: RequestObject
    
    struct RequestObject: Codable {
        let intent: String?
    }
    
    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }
    
    private struct UpdateProfile: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}

struct UpdateRelationshipStatusQuery: Query, MutatingQuery {
    var request: RequestObject
    
    struct RequestObject: Codable {
        let relationshipStatus: String?
    }
    
    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }
    
    private struct UpdateProfile: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}

struct UpdateEthnicityQuery: Query, MutatingQuery {
    var request: RequestObject
    
    struct RequestObject: Codable {
        let ethnicity: String?
    }
    
    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }
    
    private struct UpdateProfile: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}

struct UpdateKidsAtHomeQuery: Query, MutatingQuery {
    var request: RequestObject
    
    struct RequestObject: Codable {
        let kidsAtHome: String?
    }
    
    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }
    
    private struct UpdateProfile: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}

struct UpdateWantsKidsQuery: Query, MutatingQuery {
    var request: RequestObject
    
    struct RequestObject: Codable {
        let wantsKids: String?
    }
    
    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }
    
    private struct UpdateProfile: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}

struct UpdateEducationQuery: Query, MutatingQuery {
    var request: RequestObject
    
    struct RequestObject: Codable {
        let education: String?
    }
    
    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }
    
    private struct UpdateProfile: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}

struct UpdateBodyTypeQuery: Query, MutatingQuery {
    var request: RequestObject
    
    struct RequestObject: Codable {
        let bodyType: String?
    }
    
    private struct DataDTO: Codable {
        let updateProfile: UpdateProfile?
    }
    
    private struct UpdateProfile: Codable {
        let errors: [ErrorDTO]?
    }
    
    struct Response: Codable {
        private let data: DataDTO?
        var errorMessage: String? { data?.updateProfile?.errors?.first?.msg }
    }
}
