//
//  CoinData.swift
//  ByteCoin
//
//  Created by Marcos Almeida on 2025-04-03.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let time: Date
    let rate: Double
    let asset_id_quote: String
}
