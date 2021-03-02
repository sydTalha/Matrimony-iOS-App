//
//  AboutMeCell.swift
//  RajaaRani
//
//

import UIKit

class AboutMeCell: UITableViewCell {

    //MARK:- Properties
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var aboutDesc_lbl: UILabel!
    
    
    //MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
