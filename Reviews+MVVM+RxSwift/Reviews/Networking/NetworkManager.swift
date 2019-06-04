//
//  NetworkManager.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import Foundation
import RxSwift

class NetworkManager {
    
    fileprivate let baseUrlString = "https://www.airbnb.com/api/v2/homes_pdp_reviews"
    
    func getReviews(page: Int = 0, parameters: Parameters = .basic) -> Single<[Review]> {
        
        let values = parameters.values
        let params: [String : String] = [
            "key": "d306zoyjsyarp7ifhu67rjxn52tv0t20", //WARNING!!! Hardcoded key
            "listing_id": String(values.listingId),
            "limit": String(values.limit),
            "offset": String(page),
            "locale": values.locale,
            "order": values.order,
        ]
        
        var urlComponents = URLComponents(string: baseUrlString)
        urlComponents?.queryItems = params.map {
            return URLQueryItem(name: $0, value: $1)
        }
        
        guard let url = urlComponents!.url else {
            return Single.error(NetworkError.badRequest(reason: "Bad URL request!"))
        }
        
        let urlRequest = URLRequest(url: url)
        
        return Single.create(subscribe: { observer -> Disposable in
            
            URLSession.shared.rx.data(request: urlRequest)
                .asSingle()
                .subscribe(onSuccess: { data in
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let response = try decoder.decode(Response.self, from: data)
                        observer(.success(response.reviews))
                    } catch (let error) {
                        observer(.error(error))
                    }
                }, onError: {
                    observer(.error($0))
                })
        })
    }
}

enum Parameters {
    case basic
    case custom(_ params: RequestParameters)
    
    var values: RequestParameters {
        switch self {
        case .basic:
            return RequestParameters()
        case .custom(let params):
            return RequestParameters(limit: params.limit)
        }
    }
}

struct RequestParameters {
    let listingId: Int
    let order: String
    let limit: Int
    let locale: String
    
    init(limit: Int = 100, // TODO: Implement pagination
         listingId: Int = 292864,
         order: String = "language_country",
         locale: String = "en") {
        self.limit = limit
        self.listingId = listingId
        self.order = order
        self.locale = locale
    }
}

enum NetworkError: Error {
    case badRequest(reason: String)
}
