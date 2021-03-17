//
//  OrderTableViewCell.swift
//  MohammedSuleiman_MyOrder
//
//  Created by Mohammed on 2021-02-09.
// Name: Mohammed Suleiman Mohamed Al-Falahy    ID: 121083174

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet var coffeeType: UILabel!
    @IBOutlet var coffeeSize: UILabel!
    @IBOutlet var coffeeOrdered: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var bgUIImage : UIImage = UIImage(named: "unnamed")!
        let myInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         bgUIImage = bgUIImage.resizableImage(withCapInsets: myInsets)
         self.backgroundColor = UIColor.init(patternImage:bgUIImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
