//
//  Config.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Foundation

struct Token: Decodable {
    let accessToken: String
}

struct Keys: Decodable {
    let baseURL: String
    let clientId: String
    let clientSecret: String
}

struct Request: Decodable {
    let country: String
    let point: String
    let max: String
    let offset: String
    let fields: [String]
}

private enum ConfigPlist: String {
    case keys
    case request

    var value: String {
        return self.rawValue.capitalized
    }
}

struct Config: Decodable {

    var baseKeys: Keys!
    var parameters: Request!

    init() {
        baseKeys = decodedXML(for: .keys)
        parameters = decodedXML(for: .request)
    }

    // Force casting in all these instructions is justified since it's the initial configuration
    // it's referring to. The app should absolutely crash in case something goes wrong in such an early
    // phase.
    private func decodedXML<T: Decodable>(for resource: ConfigPlist) -> T {
        let keysPath = Bundle.main.path(forResource: resource.value, ofType: "plist")!
        let keysXML = FileManager.default.contents(atPath: keysPath)!
        return try! PropertyListDecoder().decode(T.self, from: keysXML)
    }

}
