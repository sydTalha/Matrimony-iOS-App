//
//  ChatTableViewCell.swift
//  RajaaRani
//
//  Created by Rizwan on 1/14/21.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    //MARK:- Properties
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var person_imgView: UIImageView!
    
    @IBOutlet weak var personName_lbl: UILabel!
    
    @IBOutlet weak var personMsg_lbl: UILabel!
    
    @IBOutlet weak var date_lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        person_imgView.layer.cornerRadius = (person_imgView.frame.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
