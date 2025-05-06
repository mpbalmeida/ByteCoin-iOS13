//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Marcos Almeida on 2025-04-03.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation

public struct CoinModel: Codable {
    public var rate: Double
    public var time: Date
    public var coin: String
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
