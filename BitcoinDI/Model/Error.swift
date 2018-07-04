//
//  Error.swift
//  BitcoinDI
//
//  Created by Luana Chen on 03/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import Foundation

struct Error: Codable{
    let id: String
    let message: String
    let url: String
}
