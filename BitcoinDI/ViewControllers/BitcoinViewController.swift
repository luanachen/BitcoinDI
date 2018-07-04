//
//  BitcoinViewController.swift
//  BitcoinDI
//
//  Created by Luana Chen on 03/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import UIKit

class BitcoinViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var primary: UILabel!
    @IBOutlet weak var partial: UILabel!
    @IBOutlet weak var refresh: UIButton!
    
    let fetcher = BitcoinPriceFetcher(networking: HTTPNetworking())

    private let dollarsDisplayFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.currencyGroupingSeparator = ","
        return formatter
    }()
    
    private let standardFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPrice()
    }
    
    // MARK: - Actions
    @IBAction func refreshTapped(_ sender: UIButton) {
        requestPrice()
    }
    
    // MARK: - Private methods
    private func updateLabel(price: Price) {
        guard let dollars = price.components().dollars,
        let cents = price.components().cents,
            let dollarAmount = standardFormatter.number(from: dollars) else { return }
        
        primary.text = dollarsDisplayFormatter.string(from: dollarAmount)
        partial.text = ".\(cents)"
    }
    
    private func requestPrice() {
        fetcher.fetch { response in
            guard let response = response else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateLabel(price: response.data)
            }
        }
    }
    
}









