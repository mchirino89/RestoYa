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
    func selectedRestaurant(_ restaurantName: String)
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

    func annotation(for title: String) -> RestaurantPinViewModel {
        return pins.first(where: { $0.title == title }) ?? pins.first!
    }

}

extension MapHandler: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newLocation = CLLocation(latitude: mapView.centerCoordinate.latitude,
                                     longitude: mapView.centerCoordinate.longitude)
        delegate?.didMovedMap(onto: newLocation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is RestaurantPinViewModel else { return nil }

        let identifier = "restaurantAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let tappedPin = view.annotation as? RestaurantPinViewModel else { return }
        delegate?.selectedRestaurant(tappedPin.title ?? "")
    }

}
