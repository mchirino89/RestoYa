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

    func setup() {
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
                    self?.token = try JSONDecodable.map(input: validData,
                                                        with: .convertFromSnakeCase)
                    print("Current token: \(self?.token?.accessToken ?? "no token from API")")
                } catch let error {
                    print(error.localizedDescription)
                }
        }
    }

    // This method should receive user's location
    func getData(from endpoint: EndPoints,
                 with parameters: [String: Any],
                 using completion: @escaping (Result<Data>) -> ()) {
        let originURL = config.baseKeys.baseURL + endpoint.value
        let mergedParameters = parameters.merging(config.baseParameters) { (_, _) in }
        print(mergedParameters)
        // .request(, encoding: URLEncoding(arrayEncoding: .noBrackets))
        Alamofire
            .request(originURL, parameters: mergedParameters)
            .validate()
            .responseData { response in
                print(response.result.description)
                completion(response.result)
        }
    }
}
