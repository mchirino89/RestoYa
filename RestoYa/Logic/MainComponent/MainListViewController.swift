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

    private lazy var mapHandler: MapHandler = {
        return MapHandler()
    }()

    @IBOutlet weak var mainMapView: MKMapView! {
        didSet {
            mainMapView.delegate = mapHandler
        }
    }

    private lazy var dataSource: RestaurantDataSource = {
        let cellId = "restaurantCell"
        return RestaurantDataSource(cellId: cellId)
    }()

    @IBOutlet private weak var listTableView: UITableView! {
        didSet {
            listTableView.delegate = self
            listTableView.dataSource = dataSource
            listTableView.estimatedRowHeight = 100
            listTableView.rowHeight = UITableView.automaticDimension
        }
    }

    private lazy var responseService: ResponseProvider = {
        return ResponseProvider(delegate: self)
    }()

    @IBOutlet weak var waitingEffectView: UIVisualEffectView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationDelegate.requestUpdate()
    }

    @IBAction func centerLocationAction(_ sender: UIBarButtonItem) {
        mainMapView.setUserTrackingMode(.follow, animated: true)
    }

    private func updateRestaurants(basedOn location: CLLocation?) {
        toggleWaiting(isHidden: false)
        responseService.fetchRestaurants(on: location)
    }
}

extension MainListViewController: ResponseHandable {

    func responseOutput(result: DataState) {
        switch result {
        case .loaded(let restaurants):
            dataSource.updateList(with: restaurants)
            mapHandler.update(restaurants.map { RestaurantPinViewModel(restaurantData: $0) })
            mainMapView.addAnnotations(mapHandler.pins)
            listTableView.reloadData()
        case .failure(let error):
            //- Retry policy would be here in a production scenario
            print("Something went wrong during service retrieving operation: \(error)")
        }
        //- Sets the delegate only after first load to avoin init recursiveness from map rendering
        mapHandler.setDelegate(self)
        toggleWaiting(isHidden: true)
    }

    private func toggleWaiting(isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.waitingEffectView.transform = isHidden ? CGAffineTransform(translationX: 0, y: 2000) : .identity
        }
    }

}

extension MainListViewController: MapHandable {

    //- Experimental feature to make map more dynamic. A proper cache policy should be implemented in
    // order to avoid so many hits to the server
    func didMovedMap(onto newLocation: CLLocation) {
        updateRestaurants(basedOn: newLocation)
    }

    func selectedRestaurant(_ restaurantName: String) {
        let selectedRow = dataSource.indexFor(restaurantName)
        let selectedIndex = IndexPath(item: selectedRow, section: 0)
        listTableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .top)
    }
}

extension MainListViewController: Locatable {

    func updated(with latest: CLLocation?) {
        locationDelegate.stopUpdate()
        updateRestaurants(basedOn: latest)
        //- Additional handling should be added in production code for alternative paths. Right now
        //  we're assuming location access is granted in order to provide full map experience
        guard let retrievedPoint = latest?.coordinate else { return }
        setWalkingDistanceZoom(for: retrievedPoint)
    }

    private func setWalkingDistanceZoom(for coordinate: CLLocationCoordinate2D) {
        let roundMeassure: Double = 3000
        let walkingRegion = MKCoordinateRegion(center: coordinate,
                                               latitudinalMeters: roundMeassure,
                                               longitudinalMeters: roundMeassure)
        mainMapView.setCenter(coordinate, animated: true)
        mainMapView.setRegion(walkingRegion, animated: true)
    }

}

extension MainListViewController: UITableViewDelegate {

    private func deselectRow() {
        guard let rowSelected = self.listTableView.indexPathForSelectedRow else { return }
        self.listTableView.deselectRow(at: rowSelected, animated: true)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        deselectRow()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        deselectRow()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        deselectRow()
    }
}
