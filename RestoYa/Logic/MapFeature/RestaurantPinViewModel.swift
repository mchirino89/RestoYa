//
//  RestaurantPinViewModel.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 27/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import MapKit

class RestaurantPinViewModel: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(restaurantData: Restaurant) {
        self.title = restaurantData.name
        self.subtitle = restaurantData.address
        self.coordinate = Location2D(retrievedPoint: nil,
                                     preloadedPoint: restaurantData.coordinates).geoPoint
    }

//    private func buildCoordinates
}
