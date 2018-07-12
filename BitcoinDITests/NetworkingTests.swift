//
//  NetworkingTests.swift
//  BitcoinDITests
//
//  Created by Luana Chen on 12/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//


import XCTest
import Swinject
import SwinjectAutoregistration
import Foundation

@testable import BitcoinDI

struct NetworkingTests: Networking {
    let fileName: String
    
    func request(from: EndPoint, completion: @escaping Networking.CompletionHandler) {
        let data = readJson(name: fileName)
        completion(data, nil)
    }
    
    private func readJson(name: String) -> Data? {
        let bundle = Bundle(for: SimulatedNetworkTests.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else { return nil }
        
        do {
            return try Data(contentsOf: url, options: .mappedIfSafe)
        }
        catch {
            XCTFail("Error occured parsing test data")
            return nil
        }
    }
}

enum DataSet: String {
    case one
    case two
    
    static let all: [DataSet] = [.one, .two]
}

extension DataSet {
    var name: String { return rawValue }
    var filename: String { return "dataset-\(rawValue)" }
}

class SimulatedNetworkTests: XCTestCase {
    
    private let container = Container()
    
    override func setUp() {
        super.setUp()
        container.autoregister(Networking.self,
                               argument: String.self,
                               initializer: NetworkingTests.init)
        
        // Registers two instances of BitcoinPriceFetcher, one for each of the available data sets.
        DataSet.all.forEach { dataSet in
            container.register(BitcoinPriceFetcher.self, name: dataSet.name) { resolver in
                let networking = resolver ~> (Networking.self, argument: dataSet.filename)
                return BitcoinPriceFetcher(networking: networking)
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
        container.removeAll()
    }
    
    // MARK: - Tests
    
    func testDatasetOne() {
        let fetcher = container ~> (BitcoinPriceFetcher.self, name: DataSet.one.name)
        let expectation = XCTestExpectation(description: "Fetch Bitcoin price from dataset one")
        
        fetcher.fetch { response in
            XCTAssertEqual("100000.01", response?.data.amount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDatasetTwo() {
        let fetcher = container ~> (BitcoinPriceFetcher.self, name: DataSet.two.name)
        let expectation = XCTestExpectation(description: "Fetch Bitcoin price from dataset two")
        
        fetcher.fetch { response in
            XCTAssertEqual("9999999.76", response!.data.amount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}




