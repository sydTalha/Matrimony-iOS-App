//
//  UserStatsFirstCell.swift
//  RajaaRani
//
//  Created by Rizwan on 1/22/21.
//

import UIKit

class UserStatsFirstCell: UITableViewCell {

    //MARK:- Properties
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var marital_lbl: UILabel!
    
    @IBOutlet weak var religion_lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
