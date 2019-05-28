//
//  Restaurant.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Foundation

//- Too small of an entity to throw into its own file
struct ServiceResponse: Decodable {
    let total: Int
    let max: Int
    let count: Int
    let offset: Int
    let data: [Restaurant]
}

struct Restaurant: Decodable {
    let logo: String
    let shippingAmount: Int
    let deliveryTimeMinMinutes: String
    let deliveryTimeMaxMinutes: String
    let address: String
    let name: String
    let generalScore: Double
    let sortingDistance: Double
    let coordinates: String
}
