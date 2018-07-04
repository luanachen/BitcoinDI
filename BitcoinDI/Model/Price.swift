//
//  Price.swift
//  BitcoinDI
//
//  Created by Luana Chen on 03/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import Foundation

enum Currency: String, Codable {
    case USD
}

enum CryptoCurrency: String, Codable {
    case BTC
}

struct Price: Codable {
    let base: CryptoCurrency
    let amount: String
    let currency: Currency
}

extension Price {
    func components() -> (dollars: String?, cents: String?) {
        let tokens = amount.components(separatedBy: ".")
        return (dollars: tokens.first, cents: tokens.last)
    }
}
