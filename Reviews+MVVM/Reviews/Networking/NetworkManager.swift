//
//  NetworkManager.swift
//  Reviews
//
//  Created by Stepan Vardanyan on .
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import Foundation
import Alamofire

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
    
    init(limit: Int = 20,
         listingId: Int = 292864,
         order: String = "language_country",
         locale: String = "en") {
        self.limit = limit
        self.listingId = listingId
        self.order = order
        self.locale = locale
    }
}

class NetworkManager {
    
    fileprivate let baseUrlString = "https://www.airbnb.com/api/v2/homes_pdp_reviews"
    
    func getReviews(page: Int = 0, parameters: Parameters = .basic, completion: @escaping (Result<Response, Error>) -> ()) {
        
        let values = parameters.values
        let params: [String : Any] = [
            "key": "d306zoyjsyarp7ifhu67rjxn52tv0t20", //WARNING!!! Hardcoded key
            "listing_id": values.listingId,
            "limit": values.limit,
            "offset": page,
            "locale": values.locale,
            "order": values.order,
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(baseUrlString, parameters: params).responseDecodable(decoder: decoder) { (response: DataResponse<Response>) in
            completion(response.result)
        }
    }
}
