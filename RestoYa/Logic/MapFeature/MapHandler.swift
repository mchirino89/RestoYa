//
//  MapHandler.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import MapKit

class MapHandler: NSObject, MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("MAP DEBUGGING - did change region animated \(mapView.centerCoordinate)")
    }

    /// TODO: Places the focus for the tapped pin on its corresponding cell row
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("MAP DEBUGGING - did tapped on \(view)")
    }


}
