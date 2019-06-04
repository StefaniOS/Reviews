//
//  NetworkManager.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import Foundation

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
    
    //WARNING!!! Hardcoded API key
    fileprivate let baseUrlString = "https://www.airbnb.com/api/v2/homes_pdp_reviews?key=d306zoyjsyarp7ifhu67rjxn52tv0t20"

    func getReviews(page: Int = 0, parameters: Parameters = .basic, completion: @escaping (Result<Response, Error>) -> ()) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let values = parameters.values
        
        let urlString = """
        \(baseUrlString)\
        &locale=\(values.locale)\
        &listing_id=\(values.listingId)\
        &limit=\(values.limit)\
        &offset=\(page)\
        &order=\(values.order)
        """
        
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            if let err = err {
                completion(.failure(err))
            }
            
            guard let httpResponse = resp as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server Error!")
                    return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(Response.self, from: data!)
                completion(.success(response))
            } catch (let jsonError){
                completion(.failure(jsonError))
            }
            
            }.resume()
    }
}
