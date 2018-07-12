//
//  SwinjectStoryboard+Extension.swift
//  BitcoinDI
//
//  Created by Luana Chen on 12/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.autoregister(Networking.self, initializer: HTTPNetworking.init)
        defaultContainer.autoregister(PriceFetcher.self, initializer: BitcoinPriceFetcher.init)
        defaultContainer.storyboardInitCompleted(BitcoinViewController.self) { resolver, controller in
            controller.fetcher = resolver ~> PriceFetcher.self
        }
    }
}
