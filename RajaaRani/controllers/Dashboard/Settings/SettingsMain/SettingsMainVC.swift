//
//  SettingsMainVC.swift
//  RajaaRani
//

//

import UIKit


class SettingsMainVC: UIViewController {
    //MARK:- Properties
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Event Handlers
    
    
}

//MARK:- Lifecycle
extension SettingsMainVC{
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
}


//MARK:- TableView Delegate and Datasoure Methods
//extension SettingsMainVC: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}

//MARK:- Helpers
extension SettingsMainVC{
    
}



