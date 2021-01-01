//
//  SettingsVC.swift
//  RajaaRani
//

//

import UIKit


class SettingsVC: UIViewController {

    
    //MARK:- Properties
    let settingsMainOpts = ["Edit Profile", "Filters and Preferences", "Settings", "Need Help?", "Report a Problem"]
    
    let settingsSubOpts = ["34% Complete", "Set Location, Age and More", "Manage Account and Chaperone", "FAQ's, Tutorials and Contact", "Get help with technical and billing issues"]
    
    let settingsIconOpts = ["person-icon", "filter-icon", "settings-icon-gray", "question-mark-gray", "problem-icon"]
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK:- Actions
    
    
    //MARK:- Event Handlers
    
    
    
    

}


//MARK:- Lifecycle
extension SettingsVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
    }
}


//MARK:- Interface Setup
extension SettingsVC{
    func setupInterface(){
        self.tableView.separatorColor = UIColor.clear
    }
    
    
}


//MARK:- TableView Delegates
extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsMainOpts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //deque cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "setting_cell") as! SettingsTableViewCell
        
        cell.name_lbl.text = self.settingsMainOpts[indexPath.row]
        cell.subtitle_lbl.text = self.settingsSubOpts[indexPath.row]
        cell.setting_imgView.image = UIImage(named: self.settingsIconOpts[indexPath.row])
        
        //UI changes
        cell.iconView.layer.cornerRadius = cell.iconView.frame.size.width/2
        cell.iconView.setSmallShadow()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
}
