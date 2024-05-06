//
//  dataBase.swift
//  Final
//
//  Created by 林柏諺 on 2023/6/16.
//

import Foundation

class Database : NSObject{
    
    static let shared = Database()
    var database: FMDatabase!
    
    var fileName: String = "SearchRecord.db" // 資料庫名稱
    var filePath: String = "" // 資料庫路徑
    
    //MARK: -  初始化
    private override init() {
        super.init()
        // 取得資料庫的路徑
        let currentFilePath = URL(fileURLWithPath: #file)
        let currentDirectoryPath = currentFilePath.deletingLastPathComponent().path
        self.filePath = currentDirectoryPath  + "/" + self.fileName
    }
    deinit {
        print("deinit: \(self)")
    }
    
    //MARK: - 判斷是否成功連線至資料庫
    func connectDB() -> Bool {
        var isConnect: Bool = false
        self.database = FMDatabase(path: self.filePath)
        if self.database != nil {
            if self.database.open() {
                isConnect = true
            } else {
                print("未連線至資料庫")
            }
        }
        return isConnect
    }
    
    //MARK: - 創建Table
    func createTable() {
        let fileManager: FileManager = FileManager.default
        // 判斷Documents是否存在該db檔
        if !fileManager.fileExists(atPath: filePath) {
            if self.connectDB() {
                // 創建資料表
                let createSearchTable = "CREATE TABLE Search(id Varchar(50) NOT NULL PRIMARY KEY,HowMuch Varchar(30) NOT NULL,currency1 Varchar(30) NOT NULL,currency2 Varchar(30) NOT NULL,Result Float NOT NULL,Date String NOT NULL)"
                self.database.executeStatements(createSearchTable)
                print("成功建立資料表於\(self.filePath)")
            }
        } else {
            print("檔案已存在於\(self.filePath)")
        }
    }
    
    //MARK: - 新增資料
    func insertData(id: String,HowMuch : String, currency1 : String, currency2 : String, Result : Float, Date : String) {
        if self.connectDB() {
            let insertData = "INSERT INTO Search(id,HowMuch,currency1,currency2,Result,Date) VALUES (?,?,?,?,?,?)"
            
            if self.database.executeUpdate(insertData, withArgumentsIn: [id,HowMuch,currency1,currency2,Result,Date]) {
                print("新增資料成功")
            }else{
                print("新增資料失敗")
                print(database.lastError(), database.lastErrorMessage())
            }
            self.database.close()
        }
    }
    
    //MARK: - 刪除資料
    func deleteData(id: String){
        if self.connectDB() {
            let deleteData = "DELETE FROM Search WHERE id = ?"
            if self.database.executeUpdate(deleteData, withArgumentsIn: [id]) {
                print("刪除資料成功")
            }else{
                print("刪除資料失敗")
                print(database.lastError(), database.lastErrorMessage())
            }
            self.database.close()
        }
    }
    
    //MARK: - 列出所有資料
    func fetchData() -> [DataBaseModel]{
        var Search = [DataBaseModel]()
        if self.connectDB(){
            let fetchData = "SELECT * FROM Search"
            do {
                let dataLists: FMResultSet = try database.executeQuery(fetchData, values: nil)
                while dataLists.next() {
                    let data: DataBaseModel = DataBaseModel(id: dataLists.string(forColumn: "id")!, HowMuch: dataLists.string(forColumn: "HowMuch")! ,currency1: dataLists.string(forColumn: "currency1")!,currency2:dataLists.string(forColumn: "currency2")! ,   Result: Float(dataLists.string(forColumn: "Result") ?? "0")!,Date: dataLists.string(forColumn: "Date")! )
                    Search.append(data)

                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return Search
    }
}
