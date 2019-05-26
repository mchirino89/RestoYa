//
//  NetworkProvider.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 25/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Alamofire
import AlamofireImage

enum ResourceType: String {
    case json
    case txt
}

class NetworkProvider {

    static let shared = NetworkProvider()
    private let imageCache: AutoPurgingImageCache

    private init() {
        imageCache = AutoPurgingImageCache()
    }

    func getData(from originURL: String, using completion: @escaping (Result<Data>) -> ()) {
        Alamofire.request(originURL).validate().responseData { response in
            print(response.result.description)
            completion(response.result)
        }
    }

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

    func updateCache(with image: UIImage, at key: String) {
        imageCache.add(image, withIdentifier: key)
    }
}

