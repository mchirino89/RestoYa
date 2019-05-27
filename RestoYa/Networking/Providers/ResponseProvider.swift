//
//  ResponseProvider.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 26/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Alamofire
import ChiriUtils

enum DataState {
    case loaded([Restaurant])
    case failure(Error)
}

struct ResponseConfig {

}

protocol ResponseHandable: class {
    func responseOutput(result: DataState)
}

class ResponseProvider {

    private weak var delegate: ResponseHandable?

    init(delegate: ResponseHandable) {
        self.delegate = delegate
    }

    func fetchRestaurants() {

        // Token doesn't exist or it has expired
        if RequestProvider.shared.token == nil {
            RequestProvider.shared.setup()
        } else {

        }
    }

    private func queryRestaurants() {
        let parameters = RequestProvider.shared.config.parameters
        let fetchParameters: [String: Any] = [ Request.Parameter.country.value: parameters.country,
                                               Request.Parameter.point.value: parameters.point,
                                               Request.Parameter.max.value: parameters.max,
                                               Request.Parameter.offset.value: parameters.offset,
                                               Request.Parameter.fields.value: parameters.fields]

        RequestProvider.shared.getData(from: .restaurants, with: fetchParameters) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let value):
                self.handleSuccessResponse(for: value, and: self.delegate)
            case .failure(let errorInfo):
                self.handleFailure(for: errorInfo, and: self.delegate)
            }
        }
    }
    
    private func handleSuccessResponse(for data: Data, and delegate: ResponseHandable?) {
        do {
            let restaurants: [Restaurant] = try JSONDecodable.map(input: data)
            let success: DataState = .loaded(restaurants)
            delegate?.responseOutput(result: success)
        } catch let error {
            handleFailure(for: error, and: delegate)
        }
    }

    private func handleFailure(for error: Error, and delegate: ResponseHandable?) {
        print("Something went wrong during JSON decoding \(error.localizedDescription)")
        let failure: DataState = .failure(error)
        delegate?.responseOutput(result: failure)
    }
}
