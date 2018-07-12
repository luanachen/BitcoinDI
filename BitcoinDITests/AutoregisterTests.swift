//
//  AutoregisterTests.swift
//  BitcoinDITests
//
//  Created by Luana Chen on 12/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import XCTest
import Swinject
import SwinjectAutoregistration

@testable import BitcoinDI

extension PriceResponse {
    init(data: Price) {
        self.init(data: data, warnings: nil)
    }
}

extension Price {
    init(amount: String) {
        self.init(base: .BTC, amount: amount, currency: .USD)
    }
}

class AutoregisterTests: XCTestCase {
    
    private let container = Container()
    
    override func setUp() {
        super.setUp()
        container.autoregister(Price.self,
                               argument: String.self,
                               initializer: Price.init(amount:))
        
        container.autoregister(PriceResponse.self,
                               argument: Price.self,
                               initializer: PriceResponse.init(data:))
    }
    
    override func tearDown() {
        super.tearDown()
        container.removeAll()
    }
    
    // MARK: - Tests
    
    func testPriceResponseData() {
        let price = container ~> (Price.self, argument: "9999")
        let response = container ~> (PriceResponse.self, argument: price)
        XCTAssertEqual(response.data.amount, "9999")
    }
    
    func testPrice() {
        let price = container ~> (Price.self, argument: "99")
        XCTAssertEqual(price.amount, "99")
    }
    
}
