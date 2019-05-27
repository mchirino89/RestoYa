//
//  LocationDelegate.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import MapKit

protocol Locatable: class {
    func updated(with latest: CLLocation)
}

class LocationDelegate: NSObject {

    weak var delegate: Locatable?
    private var manager:CLLocationManager!

    init(delegate: Locatable) {
        self.delegate = delegate
        super.init()
        manager = CLLocationManager()
        manager.delegate = self
        // Here we compromise, not using the "best" location will keep battery consumption in check
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // Another compromise, by asking only "when in use" authorization not only does battery is taken care
        // of but we avoid being to demanding on resources for the OS. The big status "X app is using
        // your location" flash can be daunting for most users unless they absolutely understand the
        // need for it.
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
        guard let latest = locations.last else {
            print("No location is available at this time")
            return
        }
        delegate?.updated(with: latest)
    }
}
