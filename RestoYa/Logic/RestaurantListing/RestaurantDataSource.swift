//
//  RestaurantDataSource.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import UIKit

// Funny fact: the compailer complains if I put the UITableViewDataSource methods in a
// extension (@objc related errors)
class RestaurantDataSource<T: Decodable>: NSObject, UITableViewDataSource {

    private let cellId: String
    private var dataSource: [T]

    init(cellId: String) {
        self.cellId = cellId
        dataSource = []
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
