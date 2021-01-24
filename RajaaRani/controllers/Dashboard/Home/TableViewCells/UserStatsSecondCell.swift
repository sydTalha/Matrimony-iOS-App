//
//  UserStatsSecondCell.swift
//  RajaaRani
//
//  Created by Rizwan on 1/22/21.
//

import UIKit

class UserStatsSecondCell: UITableViewCell {

    //MARK:- Properties
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var education_lbl: UILabel!
    @IBOutlet weak var height_lbl: UILabel!
    
    @IBOutlet weak var complection_lbl: UILabel!
    
    @IBOutlet weak var job_lbl: UILabel!
    
    @IBOutlet weak var cast_lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
