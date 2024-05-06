//
//  CurrencyInfo.swift
//  Final
//
//  Created by 林柏諺 on 2023/6/15.
//

import Foundation
import UIKit

//MARK: 定義
struct Currency {
    var name: String
    var exchangeRate: Float
}

struct CurrencyData: Codable {
    let base: String
    let rates: [ String: Float ]
}

protocol CurrencyInfoDelegate {
    func didUpdateCurrencies(currencyData: CurrencyData)
}

//MARK: -
struct CurrencyInfo {
    
    let exchangeURL = "http://api.exchangeratesapi.io/v1/latest?access_key=3338a8fc8256f278ff472c1268c99ab7"
    var currencyList: [Currency] = []
    var delegate: CurrencyInfoDelegate?
    
    var Trans : Float = 0.0
    
    mutating func renewCurrencyList(list: Array<Currency>){
        currencyList = list
    }
    
    func getCurrenciesNumber() -> Int {
        return currencyList.count
    }
    
    
    //MARK: - 取得API資料
    func performAPIRequest(urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let data = data {
                    if let safeData = parseJSON(currencyData: data){
                        delegate?.didUpdateCurrencies(currencyData:safeData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getAllExchangeRate() {
        let urlString = "\(exchangeURL)"
        performAPIRequest(urlString: urlString)
    }
    
    //MARK: - 貨幣換算
    mutating func currencyTrans (Choose : Float , TO : Float , HOW : Float){
        self.Trans = (TO / Choose) * HOW
    }
}
    
    //MARK: - 轉換JSON格式
    func parseJSON(currencyData: Data) -> CurrencyData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
  



