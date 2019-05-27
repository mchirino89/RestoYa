//
//  LocationDelegate.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import MapKit

protocol Locatable: class {
    func updated(with latest: CLLocation?)
}

class LocationDelegate: NSObject {

    weak var delegate: Locatable?
    private var manager:CLLocationManager!

    init(delegate: Locatable) {
        self.delegate = delegate
        super.init()
        manager = CLLocationManager()
        manager.delegate = self
        // In production environment the location should be handled using SLC as default option and only
        // relying on this class of accuracy on demand for battery and UX sake
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
    }

    func requestUpdate() {
        manager.startUpdatingLocation()
    }

    func stopUpdate() {
        manager.stopUpdatingLocation()
    }
}

extension LocationDelegate: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            print("No location permission granted")
            stopUpdate()
        case .authorizedWhenInUse, .authorizedAlways:
            print("We're good to go")
        default:
            print("The user hasn't made up his mind yet")
            stopUpdate()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.updated(with: locations.last)
    }
}
