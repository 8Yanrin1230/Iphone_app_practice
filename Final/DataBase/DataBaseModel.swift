//
//  DataBaseManager.swift
//  Final
//
//  Created by 林柏諺 on 2023/6/16.
//

import Foundation
class DataBaseModel : NSObject{
    var id = UUID().uuidString // 每筆資料的唯一識別碼
    var HowMuch : String //多少貨幣1
    var currency1 : String // 貨幣1
    var currency2 : String // 貨幣2
    var Result : Float //結果 = 多少貨幣2
    var Date : String // 搜尋日期
    
    init(id : String, HowMuch : String, currency1 : String, currency2 : String, Result : Float, Date : String) {
        self.id = id
        self.HowMuch = HowMuch
        self.currency1 = currency1
        self.currency2 = currency2
        self.Result = Result
        self.Date = Date
    }
}
