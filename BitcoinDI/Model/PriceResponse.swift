//
//  PriceResponse.swift
//  BitcoinDI
//
//  Created by Luana Chen on 03/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import Foundation

struct PriceResponse: Codable {
    let data: Price
    let warnings: [Error]?
}
