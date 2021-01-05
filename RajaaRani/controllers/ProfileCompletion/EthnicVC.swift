//
//  EthnicVC.swift
//  RajaaRani
//

//

import UIKit


class EthnicVC: UIViewController {

    //MARK:- Properties
    var options = ["Afghan", "African American", "Arab", "Bangladeshi", "Berber", "Asian"]
    var filteredOptions = [String]()
    var tmpOptions = [String]()
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTxtField: UITextField!
    //MARK:- Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    

}

//MARK:- Event Handlers
extension EthnicVC{
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        if text != ""{
            self.filteredOptions.removeAll()
            for opt in self.tmpOptions{
                if opt.lowercased().hasPrefix(text.lowercased()) || opt.lowercased().contains(text){
                    self.filteredOptions.append(opt)
                    
                }
            }
            self.options = self.filteredOptions
            self.tableView.reloadData()
        }
        
        if text == ""{
            self.options = tmpOptions
            self.tableView.reloadData()
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -180 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
}

//MARK:- Lifecycle
extension EthnicVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
    }
}

//MARK:- Interface Setup
extension EthnicVC{
    func setupInterface(){
        self.searchTxtField.delegate = self
        self.tmpOptions = options
        
        
        searchTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.hideKeyboardWhenTappedAround()
        
        
        //Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        searchTxtField.setLeftPaddingPoints(8)
        searchTxtField.setRightPaddingPoints(8)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
}


//MARK:- TableView delegates
extension EthnicVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ethnic_cell") as! EthnicCell
        
        cell.optLbl.text = self.options[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

//MARK:- TextField Delegates
extension EthnicVC: UITextFieldDelegate{
    
    
}

//MARK:- Helpers
extension EthnicVC{
    
}
