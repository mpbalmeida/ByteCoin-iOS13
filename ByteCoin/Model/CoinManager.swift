//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, _ coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    // External name with just to be more readable
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: URLRequest(url: url)) {( data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = parseJSON(coinData: safeData) {
                        self.delegate?.didUpdateCoin(self, coin)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let time = decodedData.time
            let coin = decodedData.asset_id_quote
            
            return CoinModel(rate: rate, time: time, coin: coin)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
