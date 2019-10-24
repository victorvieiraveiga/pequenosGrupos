//
//  ReuniaoCell.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 27/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit

class ReuniaoCell: UITableViewCell {
    
   
    @IBOutlet weak var txtData: UILabel!
    @IBOutlet weak var txtObs: UITextView!
    @IBOutlet weak var txtParticipantes: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
