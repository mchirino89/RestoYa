//
//  LocationDelegate.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import MapKit

class LocationDelegate: NSObject {

}

extension LocationDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            print("No location permission granted")
        case .authorizedWhenInUse, .authorizedAlways:
            print("We're good to go")
        default:
            print("The user hasn't made up his mind yet")
        }
    }
}
