//
//  ResponseProvider.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 26/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Alamofire
import ChiriUtils
import CoreLocation

enum DataState {
    case loaded([Restaurant])
    case failure(Error)
}

struct ResponseConfig {
    let endpoint: EndPoints
    let parameters: [String: Any]
    let headers: [String: String]
}

protocol ResponseHandable: class {
    func responseOutput(result: DataState)
}

class ResponseProvider {

    private weak var delegate: ResponseHandable?

    init(delegate: ResponseHandable) {
        self.delegate = delegate
    }

    func fetchRestaurants(on coordinates: CLLocation?) {
        // Token doesn't exist or it has expired
        if RequestProvider.shared.token == nil {
            // In a production environment, token initial setup should happen on AppDelegate's
            // didFinishLaunchingWithOptions method and a queue system would be in place to keep proper
            // serial order in services requests.
            RequestProvider.shared.setup { [unowned self] in
                self.queryRestaurants(on: coordinates)
            }
        } else {
            queryRestaurants(on: coordinates)
        }
    }

    private func buildResponseConfig(for coordinates: CLLocation?) -> ResponseConfig {
        let parameters = RequestProvider.shared.config.parameters
        let userLocation = Location2D(retrievedPoint: coordinates,
                                      preloadedPoint: parameters.point).point
        let fetchParameters: [String: Any] = [ Request.Parameter.country.value: parameters.country,
                                               Request.Parameter.point.value: userLocation,
                                               Request.Parameter.max.value: parameters.max,
                                               Request.Parameter.offset.value: parameters.offset,
                                               Request.Parameter.fields.value: parameters.fields]
        let headers = [Token.Header.authorization.value : RequestProvider.shared.token!.accessToken]
        return ResponseConfig(endpoint: .restaurants, parameters: fetchParameters, headers: headers)
    }

    private func queryRestaurants(on coordinates: CLLocation?) {
        let requestConfig = buildResponseConfig(for: coordinates)
        RequestProvider.shared.getData(basedOn: requestConfig) { [weak self] response in
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
            let retrievedResults: ServiceResponse = try JSONDecodable.map(input: data)
            let success: DataState = .loaded(retrievedResults.data)
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
