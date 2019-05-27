//
//  UserLocation.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 27/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import CoreLocation

struct UserLocation {
    let retrievedPoint: CLLocation?
    let preloadedPoint: String

    var point: String {
        guard let coordinate = retrievedPoint?.coordinate else { return preloadedPoint }
        return "\(coordinate.latitude), \(coordinate.longitude)"
    }
}
