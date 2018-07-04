//
//  BitcoinPriceFetcher.swift
//  BitcoinDI
//
//  Created by Luana Chen on 04/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import Foundation

protocol PriceFetcher {
    func fetch(response: @escaping (PriceResponse?) -> Void)
}

struct BitcoinPriceFetcher: PriceFetcher {
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetch(response: @escaping (PriceResponse?) -> Void) {
        networking.request(from: Coinbase.bitcoin) { data, error in
            if let error = error {
                print("Error requesting bitcoin price: \(error.localizedDescription)")
                response(nil)
            }
        
            let decoded = self.decodeJSON(type: PriceResponse.self, from: data)
            if let decoded = decoded {
                print("Price returned: \(decoded.data.amount)")
            }
            response(decoded)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from,
            let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
}
