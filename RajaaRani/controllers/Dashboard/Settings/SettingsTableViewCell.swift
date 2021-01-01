//
//  SettingsTableViewCell.swift
//  RajaaRani
//
//

import UIKit


class SettingsTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var name_lbl: UILabel!
    
    @IBOutlet weak var subtitle_lbl: UILabel!
    
    @IBOutlet weak var setting_imgView: UIImageView!
    
    //MARK:- Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
