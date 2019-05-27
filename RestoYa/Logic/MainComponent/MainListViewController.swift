//
//  MainListViewController.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import UIKit
import MapKit

class MainListViewController: UIViewController {

    private lazy var locationDelegate: LocationDelegate = {
        return LocationDelegate(delegate: self)
    }()

    private lazy var mapDelegate: MapHandler = {
        return MapHandler()
    }()

    @IBOutlet weak var mainMapView: MKMapView! {
        didSet {
            mainMapView.delegate = mapDelegate
        }
    }

    private lazy var dataSource: RestaurantDataSource<Restaurant> = {
        let cellId = "userCell"
        return RestaurantDataSource(cellId: cellId)
    }()

    @IBOutlet private weak var listTableView: UITableView! {
        didSet {
            listTableView.delegate = self
            listTableView.dataSource = dataSource
            listTableView.rowHeight = 120
        }
    }

    private lazy var responseService: ResponseProvider = {
        return ResponseProvider(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        responseService.fetchRestaurants()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationDelegate.requestUpdate()
    }
}

extension MainListViewController: ResponseHandable {
    func responseOutput(result: DataState) {
        print("Fetch restaurants result: \(result)")
    }
}

extension MainListViewController: Locatable {
    func updated(with latest: CLLocation) {
        print("Location retrieved: \(latest)")
        locationDelegate.stopUpdate()
        setWalkingDistanceZoom(for: latest.coordinate)
    }

    private func setWalkingDistanceZoom(for coordinate: CLLocationCoordinate2D) {
        let roundMeassure: Double = 2000
        let walkingRegion = MKCoordinateRegion(center: coordinate,
                                               latitudinalMeters: roundMeassure,
                                               longitudinalMeters: roundMeassure)
        mainMapView.setCenter(coordinate, animated: true)
        mainMapView.setRegion(walkingRegion, animated: true)
    }
}

extension MainListViewController: UITableViewDelegate {
    /// Focus map's camera on restaurants location
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

