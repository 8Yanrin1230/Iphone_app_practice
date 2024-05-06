//
//  CurrencyViewController.swift
//  Final
//
//  Created by 林柏諺 on 2023/6/15.
//

import UIKit
import CoreLocation

class CurrencyViewController: UIViewController , UIPickerViewDataSource , UIPickerViewDelegate , CLLocationManagerDelegate , CurrencyInfoDelegate {
    
    
    @IBOutlet weak var PickerView: UIPickerView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Label2: UILabel!
    
    let locationManager = CLLocationManager()
    var currencies = CurrencyInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PickerView.delegate = self
        PickerView.dataSource = self
        currencies.delegate = self
        
        Database.shared.createTable()
        currencies.getAllExchangeRate()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //MARK: - 設定pickerView內容
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.getCurrenciesNumber()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies.currencyList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencyRate = currencies.currencyList[PickerView.selectedRow(inComponent: 0)].exchangeRate
        Label.text = String(currencyRate)
    }
    
    //MARK: - 把各國轉換成TWD的匯率比較
    func didUpdateCurrencies(currencyData: CurrencyData) {
        DispatchQueue.main.async {
            if currencyData.rates.count > 1 {
                var newList: [Currency] = []
                var TWD : Float = 0.0

                for countries in currencyData.rates{
                    if countries.key == "TWD"{TWD = countries.value}
                }
                
                for item in currencyData.rates {
                    print(Currency(name: item.key, exchangeRate: TWD/item.value))
                    newList.append(Currency(name: item.key, exchangeRate: TWD/item.value))
                }
                
                self.currencies.renewCurrencyList(list: newList)
                self.PickerView.reloadAllComponents()
            }
        }
    }
    
    //MARK: - 管理location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("latitude: \(location.coordinate.latitude), longtitude: \(location.coordinate.longitude)")
        }
    }
}




