//
//  RestaurantViewModel.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 27/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import UIKit

struct RestaurantViewModel {

    private let data: Restaurant

    private var deliveryTime: String {
        return "⏱ \(data.deliveryTimeMinMinutes)-\(data.deliveryTimeMaxMinutes)min"
    }

    private var shippingCost: String {
        return data.shippingAmount > 0 ? "💸 $\(data.shippingAmount) envío" : "🎉 ¡Envío gratis!"
    }

    private var rating: String {
        switch data.generalScore {
        case (1..<2):
            return "🤢"
        case (2..<3):
            return "😕"
        case (3..<4):
            return "😋"
        case (4..<4.5):
            return "😍"
        case (4.5...5):
            return "🤤"
        //- Anything below 1 general score is not eatable
        default:
            return "🤮"
        }
    }

    init(data: Restaurant) {
        self.data = data
    }

    func setup(_ cellView: RestaurantViewCell) {
        cellView.nameLabel.text = data.name
        cellView.addressLabel.text = data.address
        cellView.timeLabel.text = deliveryTime
        cellView.shippingLabel.text = shippingCost
        cellView.ratingLabel.text = rating
    }

}
