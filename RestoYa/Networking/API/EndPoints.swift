//
//  EndPoints.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 26/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

enum EndPoints: String {
    case token
    case restaurants

    var value: String {
        switch self {
        case .token:
            return "tokens"
        case .restaurants:
            return "search/restaurants"
        }
    }
}
