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
        let location = LocationDelegate()
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

}

extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
