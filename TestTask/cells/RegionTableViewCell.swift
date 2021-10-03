//
//  RegionTableViewCell.swift
//  TestTask
//
//  Created by Danil Gerasimov on 03.10.2021.
//

import UIKit

class RegionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var regionNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String) {
        regionNameLabel.text = name
    }
}

