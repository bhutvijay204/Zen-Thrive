//
//  TableViewCell.swift
//  Zen Thrive
//
//  Created by Hitesh Mac on 18/05/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var LablCell: UILabel!
    
    @IBOutlet weak var DateCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
