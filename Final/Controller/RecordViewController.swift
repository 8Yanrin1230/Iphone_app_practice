//
//  RecordViewController.swift
//  Final
//
//  Created by 林柏諺 on 2023/6/15.
//

import UIKit

class RecordViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate{
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var resumeList = [DataBaseModel]() //讀取資料的List
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.isScrollEnabled = true
    }
    
    
    //MARK: - 設定collectionView內容
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resumeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"RCell", for: indexPath) as! RecordCollectionViewCell
        
        cell.HowMuch.text = "HowMuch   " + resumeList[indexPath.row].HowMuch
        cell.Currency1.text = "Currency   " + resumeList[indexPath.row].currency1
        cell.Currency2.text = "Currency   " + resumeList[indexPath.row].currency2
        cell.Result.text = "Result   " + String(format: "%.4f", resumeList[indexPath.row].Result)
        cell.Date.text = "Date   " + resumeList[indexPath.row].Date
        
        cell.delegate = self
        cell.tag = indexPath.item //取得點擊了哪個cell
        return cell
    }
    
    //MARK: - 讀取Database中的資料
    func fetchData(){
        resumeList = Database.shared.fetchData()
        DispatchQueue.main.async {
        }
    }
}

//MARK: - 當刪除鍵被點擊時
extension RecordViewController : RecordCollectionViewCellListener{
    func buttonClicked(buttonType: String, index: Int) {
        Database.shared.deleteData(id: resumeList[index].id)
        self.fetchData()
        CollectionView.reloadData()
    }
}




