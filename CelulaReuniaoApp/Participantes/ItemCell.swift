//
//  ItemCell.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 06/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var dataNascimentoLbel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var foto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
