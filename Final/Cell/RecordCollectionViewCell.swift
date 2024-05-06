//
//  RecordCollectionViewCell.swift
//  Final
//
//  Created by 林柏諺 on 2023/6/17.
//

import UIKit

var index = 0

protocol RecordCollectionViewCellListener{
    func buttonClicked(buttonType: String, index: Int)
}

class RecordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Delete: UIButton!
    @IBOutlet weak var HowMuch: UILabel!
    @IBOutlet weak var Currency1: UILabel!
    @IBOutlet weak var Currency2: UILabel!
    @IBOutlet weak var Result: UILabel!
    @IBOutlet weak var Date: UILabel!
    
    var delegate: RecordCollectionViewCellListener?
    
    @IBAction func Click(_ sender: Any) {
        self.delegate?.buttonClicked(buttonType: "delete", index: self.tag)
    }
}
