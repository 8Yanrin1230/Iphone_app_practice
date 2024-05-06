//
//  SearchViewController.swift
//  Final
//
//  Created by 林柏諺 on 2023/6/16.
//

import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate, CurrencyInfoDelegate{
    
    var currencies = CurrencyInfo()
    
    var menuChildren1: [UIAction] = []
    var menuChildren2: [UIAction] = []
    
    var ChooseValue : Float = 0.0
    var ChooseName : String = ""
    var TOValue : Float = 0.0
    var TOName : String = ""
    
    var HowMuch : String = ""
    var currentDate = Date()
    var formattedDate : String = ""
    
    @IBOutlet weak var Currency1: UIButton!
    @IBOutlet weak var Currency2: UIButton!
    @IBOutlet weak var Caculate: UIButton!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var Result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextField.text = ""
        TextField.delegate = self
        currencies.delegate = self
        currencies.performAPIRequest(urlString:"http://api.exchangeratesapi.io/v1/latest?access_key=3338a8fc8256f278ff472c1268c99ab7")
    }
    
    //MARK: - Button的功能
    @IBAction func Caculate (_ sender: Any) {
        if textFieldShouldReturn(TextField) == true{
            getCurrentDate()
            HowMuch = TextField.text ?? "1"
            currencies.currencyTrans(Choose: ChooseValue, TO: TOValue , HOW: Float(HowMuch)!)
            Database.shared.insertData(id: UUID().uuidString, HowMuch: HowMuch, currency1: ChooseName , currency2: TOName , Result: currencies.Trans, Date: formattedDate)
            Result.text = "結果：\(HowMuch) \(ChooseName) = \(String(format: "%.0f",currencies.Trans)) \(TOName)"
        }
    }
    
    //MARK: - 製作menu
    func didUpdateCurrencies(currencyData: CurrencyData) {
        DispatchQueue.main.async {
            
            if currencyData.rates.count > 1 {
                for item in currencyData.rates {
                    let action1 = UIAction(title: item.key) { [self] UIAction in
                        self.ChooseValue = item.value
                        self.ChooseName = item.key
                    }
                    let action2 = UIAction(title: item.key) { [self] UIAction in
                        self.TOValue = item.value
                        self.TOName = item.key
                    }
                    self.menuChildren1.append(action1)
                    self.menuChildren2.append(action2)
                }
            }
            let menu1 = UIMenu(title: "", children: self.menuChildren1)
            self.Currency1.menu = menu1
            self.Currency1.setTitle("請選擇貨幣", for: .normal)
            let menu2 = UIMenu(title: "", children: self.menuChildren2)
            self.Currency2.menu = menu2
            self.Currency2.setTitle("請選擇貨幣", for: .normal)
        }
    }
    
    //MARK: - 取得當前時間
    func getCurrentDate () {
        currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formattedDate = dateFormatter.string(from: currentDate)
    }
    
    //MARK: - 檢查TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        // 檢查輸入的字元是否為數字
        if !allowedCharacters.isSuperset(of: characterSet) {
            showToast(message: "只能輸入數字")
        }
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 檢查輸入的字元是否有輸入字元
        if textField.text?.isEmpty == true {
            showToast(message: "請輸入多少貨幣")
            return false
        }
        return true
    }
    
    //MARK: -產生Toast
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()})
    }
}
