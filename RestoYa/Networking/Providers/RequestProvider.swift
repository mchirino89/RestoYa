//
//  NetworkProvider.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Alamofire
import ChiriUtils

class RequestProvider {

    static let shared = RequestProvider()
    let config: Config
    var token: Token?

    private init() {
        config = Config()
    }

    func setup(completion: @escaping () -> ()) {
        let tokenURL = config.baseKeys.baseURL + EndPoints.token.value
        Alamofire
            .request(tokenURL, parameters: config.baseParameters)
            .validate()
            .responseData { [weak self] dataResponse in
                guard let validData = dataResponse.data else {
                    print("Something went transforming token's raw data")
                    self?.token = nil
                    return
                }
                do {
                    self?.token = try JSONDecodable.map(input: validData, with: .convertFromSnakeCase)
                    completion()
                    print("Current token: \(self?.token?.accessToken ?? "no token from API")")
                } catch let error {
                    print(error.localizedDescription)
                }
        }
    }

    func getData(basedOn responseConfig: ResponseConfig, with completion: @escaping (Result<Data>) -> ()) {
        let originURL = config.baseKeys.baseURL + responseConfig.endpoint.value
        let mergedParameters = responseConfig.parameters.merging(config.baseParameters) { (_, _) in return true }
        Alamofire
            .request(originURL, parameters: mergedParameters, headers: responseConfig.headers)
            .validate()
            .responseData { response in
                print(response.result.description)
                completion(response.result)
        }
    }
}
