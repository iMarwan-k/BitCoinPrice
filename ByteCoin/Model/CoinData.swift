//
//  CoinData.swift
//  ByteCoin
//
//  Created by Marwan Khalawi on 2/25/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

struct CoinData: Decodable {
    let rate: Double    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
