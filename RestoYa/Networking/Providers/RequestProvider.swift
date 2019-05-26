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
    private let config: Config
    private var baseParameters: [String: String] {
        return ["clientId": config.baseKeys.clientId,
                "clientSecret": config.baseKeys.clientSecret]
    }
    var token: Token?

    private init() {
        config = Config()
    }

    func setup() {
        let tokenURL = config.baseKeys.baseURL + EndPoints.token.value

        Alamofire
            .request(tokenURL,
                     method: .get,
                     parameters: baseParameters,
                     encoding: URLEncoding(arrayEncoding: .noBrackets))
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

    func getData(from endpoint: EndPoints, using completion: @escaping (Result<Data>) -> ()) {
        let originURL = config.baseKeys.baseURL + endpoint.value
        Alamofire.request(originURL).validate().responseData { response in
            print(response.result.description)
            completion(response.result)
        }
    }
}
