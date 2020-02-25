//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePicker(price: String, currency: String)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "7718D1F6-33AC-4EC3-AD7F-8FD1EC99C68E"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate : CoinManagerDelegate?
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString, currency: currency)
    }
    
    func performRequest(with url: String, currency: String){
        if let requestUrl = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: requestUrl) { (data, respons, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let coinPrice = self.parseJSON(data: safeData) {
                        self.delegate?.didUpdatePicker(price: coinPrice.rateString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            let coinPrice = CoinData(rate: rate)
            
            return coinPrice
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
