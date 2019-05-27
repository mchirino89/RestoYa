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
        let location = LocationDelegate(delegate: self)
        return location
    }()

    private lazy var mapDelegate: MapHandler = {
        let mapHandler = MapHandler()
        return mapHandler
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

    }
}

extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
