//
//  TabBarController.swift
//  Final
//
//  Created by 林柏諺 on 2023/6/15.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
//MARK: - 當切換成Record畫面時 會更新內容
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let recordViewController = viewController as? RecordViewController {
            recordViewController.fetchData()
            recordViewController.CollectionView.reloadData()
        }
    }
}
