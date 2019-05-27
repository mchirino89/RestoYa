//
//  RestaurantDataSource.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import ChiriUtils

// Fun fact: the compailer complains if I put the UITableViewDataSource methods in a
// extension (@objc related errors)
class RestaurantDataSource: NSObject, UITableViewDataSource {

    private let cellId: String
    private var dataSource: [Restaurant]

    init(cellId: String) {
        self.cellId = cellId
        dataSource = []
    }

    func updateList(with dataSource: [Restaurant]) {
        self.dataSource.removeAll()
        //- This should arrive sorted but I didn't find how to ask for it
        self.dataSource = dataSource.sorted(by: { $0.sortingDistance < $1.sortingDistance })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentRestaurant: Restaurant = dataSource[indexPath.row]
        let cell: RestaurantViewCell = tableView.deque(for: cellId)
        cell.setup(RestaurantViewModel(data: currentRestaurant))
        return cell
    }

}
