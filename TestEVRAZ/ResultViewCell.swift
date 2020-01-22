//
//  ResultViewCell.swift
//  TestEVRAZ
//
//  Created by Kuzhelev Anton on 22.01.2020.
//  Copyright © 2020 Kuzhelev Anton. All rights reserved.
//

import UIKit

class ResultViewCell: UITableViewCell {

    var result : Result! { didSet {
            carNameLable.text = result.name
            timeLable.text = result.time
        }
    }
    var number : Int! { didSet {
        numberLable.text = String(number)
        }
        
    }
    
    @IBOutlet weak var numberLable: UILabel!
    @IBOutlet weak var carNameLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
