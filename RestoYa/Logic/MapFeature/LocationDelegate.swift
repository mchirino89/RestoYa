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
    private var locationManager: CLLocationManager?

    init(delegate: Locatable) {
        self.delegate = delegate
        super.init()
    }

    func requestUpdate() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //- In production environment the location should be handled using SLC as default option and only
        //  relying on this class of accuracy on demand for battery and UX sake
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    func stopUpdate() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
}

extension LocationDelegate: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            print("No location permission granted")
            delegate?.updated(with: nil)
            stopUpdate()
        case .authorizedWhenInUse, .authorizedAlways:
            print("We're good to go")
			delegate?.updated(with: nil)
        default:
            print("The user hasn't made up his mind yet")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        stopUpdate()
        delegate?.updated(with: locations.last)
    }
}
