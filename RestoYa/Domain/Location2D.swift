//
//  UserLocation.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 27/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import CoreLocation

struct Location2D {
    let retrievedPoint: CLLocation?
    let preloadedPoint: String

    var point: String {
        guard let coordinate = retrievedPoint?.coordinate else { return preloadedPoint }
        return "\(coordinate.latitude), \(coordinate.longitude)"
    }

    var geoPoint: CLLocationCoordinate2D {
        let stringLocation = preloadedPoint.split(separator: ",")
        let latitude = Double(stringLocation.first ?? "") ?? 0.0
        let longitude = Double(stringLocation.last ?? "") ?? 0.0
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
