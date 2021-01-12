//
//  ProfileDetailView.swift
//  RajaaRani
//
//  Created by Rizwan on 12/21/20.
//

import UIKit

class ProfileDetailView: UIView {

    //MARK:- Outlets
    @IBOutlet var content_view: UIView!
    
    @IBOutlet weak var martialStatus_lbl: UILabel!
    
    @IBOutlet weak var religion_lbl: UILabel!
    
    @IBOutlet weak var cast_lbl: UILabel!
    
    @IBOutlet weak var height_lbl: UILabel!
    
    @IBOutlet weak var color_lbl: UILabel!
    
    @IBOutlet weak var education_lbl: UILabel!
    
    @IBOutlet weak var job_lbl: UILabel!
    
    
    
    //MARK:- Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ProfileDetails", owner: self, options: nil)
        addSubview(content_view)
        content_view.frame = self.bounds
        content_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
