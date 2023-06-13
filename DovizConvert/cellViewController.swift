//
//  cellViewController.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 13.06.2023.
//

import UIKit

struct Currency {
    let name: String
    let flagImage: UIImage
    let value: String
}


class cellViewController: UITableViewCell {
    
    @IBOutlet weak var moneyFlagImage: UIImageView!
    @IBOutlet weak var moneyUnitLabel: UILabel!
    @IBOutlet weak var moneyProvision: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
