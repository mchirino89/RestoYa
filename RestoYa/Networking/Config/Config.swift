//
//  Config.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Foundation

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

struct Config: Decodable {

    let baseKeys: Keys
    let paramters: Request

//    init() {
//        baseKeys = decodedXML(for: "Keys")
//        paramters = decodedXML(for: "Request")
//    }

    // Force casting in all these instructions is justified since it's the initial configuration
    // it's referring to. The app should absolutely crash in case something goes wrong in such an early
    // phase.
    private func decodedXML<T: Decodable>(for resource: String) -> T {
        let keysPath = Bundle.main.path(forResource: resource, ofType: "plist")!
        let keysXML = FileManager.default.contents(atPath: keysPath)!
        return try! PropertyListDecoder().decode(T.self, from: keysXML)
    }

}
