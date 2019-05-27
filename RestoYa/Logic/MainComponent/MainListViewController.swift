//
//  MainListViewController.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationDelegate.requestUpdate()
    }
}

extension MainListViewController: ResponseHandable {
    func responseOutput(result: DataState) {
        switch result {
        case .loaded(let restaurants):
            print("Successfully obtain restaurants: \(restaurants)")
        case .failure(let error):
            print("Something went wrong during service retrieving operation: \(error)")
        }
    }
}

extension MainListViewController: Locatable {
    func updated(with latest: CLLocation?) {
        print("Location retrieved: \(String(describing: latest))")
        locationDelegate.stopUpdate()
        responseService.fetchRestaurants(on: latest)
        // Additional handling should be added in production code for alternative paths. Right now
        // we're assuming location access is granted in order to provide full map experience
        guard let retrievedPoint = latest?.coordinate else { return }
        setWalkingDistanceZoom(for: retrievedPoint)
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

