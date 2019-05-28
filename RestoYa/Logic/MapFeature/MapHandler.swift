//
//  MapHandler.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import MapKit

protocol MapHandable: class {
    func didMovedMap(onto newLocation: CLLocation)
}

class MapHandler: NSObject {

    private weak var delegate: MapHandable?
    private(set) var pins: [RestaurantPinViewModel]

    override init() {
        pins = []
        super.init()
        pins.reserveCapacity(RequestProvider.shared.config.pagingSize)
    }

    func setDelegate(_ delegate: MapHandable) {
        self.delegate = delegate
    }

    func update(_ incomingPins: [RestaurantPinViewModel]) {
        pins.removeAll(keepingCapacity: true)
        pins.append(contentsOf: incomingPins)
    }

}

extension MapHandler: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print("MAP DEBUGGING - did change region animated \(mapView.centerCoordinate)")
        let newLocation = CLLocation(latitude: mapView.centerCoordinate.latitude,
                                     longitude: mapView.centerCoordinate.longitude)
        delegate?.didMovedMap(onto: newLocation)
    }

    /// TODO: Places the focus for the tapped pin on its corresponding cell row
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("MAP DEBUGGING - did tapped on \(view)")
    }

}
