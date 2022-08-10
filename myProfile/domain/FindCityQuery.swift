//
//  FindCityQuery.swift
//  Meetville
//
//  Created by Yauheni Skiruk on 24.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

struct FindCityQuery: Query {
    let input: String

    struct Response: Codable {
        private let data: DataDTO?
        var cities: [CityDTO]? { data?.viewer?.cities }
    }

    struct DataDTO: Codable {
        let viewer: ViewerDTO?
    }

    struct ViewerDTO: Codable {
        let cities: [CityDTO]?
    }

    var body: String {
        let fileName = String("\(type(of: self))".split(separator: ".").last!)
        let contentOfFile = Bundle.main.path(forResource: fileName, ofType: "query")!
        let requestString = try! String(contentsOfFile: contentOfFile)
        return String(format: requestString, input)
    }
}
