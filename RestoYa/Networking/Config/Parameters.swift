//
//  Parameters.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 27/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Foundation

struct Token: Decodable {
    let accessToken: String

    enum Header: String {
        case authorization

        var value: String {
            return self.rawValue.capitalized
        }
    }
}

struct Keys: Decodable {
    let baseURL: String
    let clientId: String
    let clientSecret: String

    init() {
        baseURL = ""
        clientId = ""
        clientSecret = ""
    }

    enum Parameter: String {
        case clientId
        case clientSecret

        var value: String {
            return self.rawValue
        }
    }
}

struct Request: Decodable {
    let country: String
    let point: String
    let max: String
    let offset: String
    let fields: [String]

    init() {
        country = ""
        point = ""
        max = ""
        offset = ""
        fields = []
    }

    enum Parameter: String {
        case country
        case point
        case max
        case offset
        case fields

        var value: String {
            return self.rawValue
        }
    }
}
