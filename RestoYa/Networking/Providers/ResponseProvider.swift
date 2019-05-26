//
//  ResponseProvider.swift
//  RestoYa
//
//  Created by Mauricio Chirino on 26/05/2019.
//  Copyright © 2019 Mauricio Chirino. All rights reserved.
//

import Alamofire

enum DataState {
    case loaded([Restaurant])
    case failure(Error)
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
        RequestProvider.shared.getData(from: .restaurants) { [weak self] response in
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
        let decode = JSONDecoder()
        do {
            let users: [Restaurant] = try decode.decode([Restaurant].self, from: data)
            let success: DataState = .loaded(users)
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
