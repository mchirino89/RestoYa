//
//  Restaurant.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Foundation

// Too small of an entity to throw into its own file
struct ServiceResponse: Decodable {
    let data: [Restaurant]
}

struct Restaurant: Decodable {
    let logo: String
    let shippingAmount: Int
    let distance: Double
    let deliveryTime: String
    let address: String
    let speed: Double
    let food: Double
    let name: String
    let rating: String
    let generalScore: Double
    let sortingDistance: Double
    let coordinates: String
}
