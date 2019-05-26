//
//  NetworkProvider.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Alamofire
import AlamofireImage

class RequestProvider {

    static let shared = RequestProvider()
    private let imageCache: AutoPurgingImageCache
    private let config: Config
    private var baseParameters: [String: String] {
        return ["clientId": config.baseKeys.clientId,
                "clientSecret": config.baseKeys.clientSecret]
    }
    var token: Token?

    private init() {
        imageCache = AutoPurgingImageCache()
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
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let validData = dataResponse.data else {
                    print("Something went transforming token's raw data")
                    return
                }
                do {
                    let updatedToken = try decoder.decode(Token.self, from: validData)
                    self?.token = updatedToken
                    print("Current token: \(self?.token?.accessToken ?? "no token from API")")
                } catch let error {
                    print(error)
                    print("Something went wrong decoding token's response")
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

    // TODO: This method should be used to retrieve thumbnail images for restaurant's list (amoung other things)
    func getImage(from originURL: String, using completion: @escaping (Result<Image>) -> ()) {
        guard let savedImage = imageCache.image(withIdentifier: originURL) else {
            Alamofire.request(originURL).responseImage { retrievedImage in
                print(retrievedImage.description)
                completion(retrievedImage.result)
            }
            return
        }
        let success: Result<Image> = .success(savedImage)
        completion(success)
    }

    /// Updates image's asset on cache
    func updateCache(with image: UIImage, at key: String) {
        imageCache.add(image, withIdentifier: key)
    }
}
