//
//  RestaurantViewCell.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 27/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import UIKit

class RestaurantViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    func setup(_ cell: RestaurantViewModel) {
        cell.setup(self)
    }

}
