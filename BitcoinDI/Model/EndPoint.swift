//
//  EndPoint.swift
//  BitcoinDI
//
//  Created by Luana Chen on 03/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import Foundation

protocol EndPoint {
    var path: String { get }
}

enum Coinbase {
    case bitcoin
}

extension Coinbase: EndPoint {
    var path: String {
        switch self {
        case .bitcoin: return "https://api.coinbase.com/v2/prices/BTC-USD/spot"
        }
    }
}
