//
//  FiltersVC.swift
//  RajaaRani
//

//

import UIKit
import TGPControls
import RangeSeekSlider

class FiltersVC: UIViewController {

    //MARK:- Properties
    let dressOptions = ["Modest", "Hijab", "Niqab"]
    let incomeOptions = ["Up to 15,000", "15,000 - 25,000", "25,000 - 50,000", "50,000 - 100,000", "More Than 100,000"]
    let educationOptions = ["Metric Degree", "High School Degree", "Diploma", "Associate Degree", "Bachelors", "Masters Degree", "Doctoral Degree"]
    
    var personalAttrLastSelection: IndexPath!
    var incomeLastSelection: IndexPath!
    var educationLastSelection: IndexPath!
    
    var user: User?
    var filterModel = FilterModel()
    
    //MARK:- Outlets
    
    //converted btns
    @IBOutlet weak var convertYesBtn: UIButton!
    @IBOutlet weak var convertNoBtn: UIButton!
    
    //halal food btns
    @IBOutlet weak var alwaysHalalBtn: UIButton!
    @IBOutlet weak var usuallyHalalBtn: UIButton!
    @IBOutlet weak var neverHalalBtn: UIButton!
    
    //religiousness btns
    @IBOutlet weak var veryReligiousBtn: UIButton!
    @IBOutlet weak var somehowReligiousBtn: UIButton!
    @IBOutlet weak var notReligiousBtn: UIButton!
    
    //marital status btns
    @IBOutlet weak var singleBtn: UIButton!
    @IBOutlet weak var marriedBtn: UIButton!
    @IBOutlet weak var divorcedBtn: UIButton!
    @IBOutlet weak var widowedBtn: UIButton!
    
    //about to marry btns
    @IBOutlet weak var verySoonBtn: UIButton!
    @IBOutlet weak var thisYearBtn: UIButton!
    @IBOutlet weak var nextYearBtn: UIButton!
    
    //smoking btns
    @IBOutlet weak var regularlyBtn: UIButton!
    @IBOutlet weak var occasionallyBtn: UIButton!
    @IBOutlet weak var neverBtn: UIButton!
    
    //prayer slider + labels
    @IBOutlet weak var prayerSlider: TGPDiscreteSlider!
    @IBOutlet weak var payerCamelLabels: TGPCamelLabels!
    
    //tableViews
    @IBOutlet weak var personalAttrTableView: UITableView!
    @IBOutlet weak var incomeTableView: UITableView!
    @IBOutlet weak var educationTableView: UITableView!
    
    
    //age range slider
    @IBOutlet weak var ageRangeSlider: RangeSeekSlider!
    @IBOutlet weak var heightRangeSlider: RangeSeekSlider!
    
    //MARK:- Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        
    }
    
    
    //MARK:- Converted
    @IBAction func convertYesTaped(_ sender: UIButton) {
        UIView.transition(with: self.convertYesBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.convertYesBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.convertYesBtn.setTitleColor(.white, for: .normal)
            self?.convertYesBtn.layer.borderWidth = 0
            
            self?.convertNoBtn.backgroundColor = .white
            self?.convertNoBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.convertNoBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.converted = 1
    }
    @IBAction func convertNoTapped(_ sender: UIButton) {
        UIView.transition(with: self.convertNoBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.convertNoBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.convertNoBtn.setTitleColor(.white, for: .normal)
            self?.convertNoBtn.layer.borderWidth = 0
            
            self?.convertYesBtn.backgroundColor = .white
            self?.convertYesBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.convertYesBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.converted = 0
    }
    
    //MARK:- Halal Food
    @IBAction func alwaysHalalTapped(_ sender: UIButton) {
        UIView.transition(with: self.alwaysHalalBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.alwaysHalalBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.alwaysHalalBtn.setTitleColor(.white, for: .normal)
            self?.alwaysHalalBtn.layer.borderWidth = 0
            
            
            self?.usuallyHalalBtn.backgroundColor = .white
            self?.usuallyHalalBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.usuallyHalalBtn.layer.borderWidth = 2
            
            
            self?.neverHalalBtn.backgroundColor = .white
            self?.neverHalalBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.neverHalalBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.food = 2
    }
    @IBAction func usuallyHalalTapped(_ sender: UIButton) {
        UIView.transition(with: self.usuallyHalalBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.usuallyHalalBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.usuallyHalalBtn.setTitleColor(.white, for: .normal)
            self?.usuallyHalalBtn.layer.borderWidth = 0
            
            
            self?.alwaysHalalBtn.backgroundColor = .white
            self?.alwaysHalalBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.alwaysHalalBtn.layer.borderWidth = 2
            
            
            self?.neverHalalBtn.backgroundColor = .white
            self?.neverHalalBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.neverHalalBtn.layer.borderWidth = 2
            
        }, completion: nil)
        filterModel.food = 1
    }
    @IBAction func neverHalalTapped(_ sender: UIButton) {
        UIView.transition(with: self.neverHalalBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.neverHalalBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.neverHalalBtn.setTitleColor(.white, for: .normal)
            self?.neverHalalBtn.layer.borderWidth = 0
            
            
            self?.alwaysHalalBtn.backgroundColor = .white
            self?.alwaysHalalBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.alwaysHalalBtn.layer.borderWidth = 2
            
            
            self?.usuallyHalalBtn.backgroundColor = .white
            self?.usuallyHalalBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.usuallyHalalBtn.layer.borderWidth = 2
            
        }, completion: nil)
        filterModel.food = 0
    }
    
    //MARK:- Religiousness
    @IBAction func veryReligiousTapped(_ sender: UIButton) {
        UIView.transition(with: self.veryReligiousBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.veryReligiousBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.veryReligiousBtn.setTitleColor(.white, for: .normal)
            self?.veryReligiousBtn.layer.borderWidth = 0
            
            
            self?.somehowReligiousBtn.backgroundColor = .white
            self?.somehowReligiousBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.somehowReligiousBtn.layer.borderWidth = 2
            
            
            self?.notReligiousBtn.backgroundColor = .white
            self?.notReligiousBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.notReligiousBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.religiousness = 2
        
    }
    @IBAction func somehowTapped(_ sender: UIButton) {
        UIView.transition(with: self.somehowReligiousBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.somehowReligiousBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.somehowReligiousBtn.setTitleColor(.white, for: .normal)
            self?.somehowReligiousBtn.layer.borderWidth = 0
            
            
            self?.veryReligiousBtn.backgroundColor = .white
            self?.veryReligiousBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.veryReligiousBtn.layer.borderWidth = 2
            
            
            self?.notReligiousBtn.backgroundColor = .white
            self?.notReligiousBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.notReligiousBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.religiousness = 1
    }
    @IBAction func notReligiousTapped(_ sender: UIButton) {
        UIView.transition(with: self.notReligiousBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.notReligiousBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.notReligiousBtn.setTitleColor(.white, for: .normal)
            self?.notReligiousBtn.layer.borderWidth = 0
            
            
            self?.somehowReligiousBtn.backgroundColor = .white
            self?.somehowReligiousBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.somehowReligiousBtn.layer.borderWidth = 2
            
            
            self?.veryReligiousBtn.backgroundColor = .white
            self?.veryReligiousBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.veryReligiousBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.religiousness = 0
    }
    
    //MARK:- Marital Status
    @IBAction func singleBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.singleBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.singleBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.singleBtn.setTitleColor(.white, for: .normal)
            self?.singleBtn.layer.borderWidth = 0
            
            
            self?.marriedBtn.backgroundColor = .white
            self?.marriedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.marriedBtn.layer.borderWidth = 2
            
            
            self?.divorcedBtn.backgroundColor = .white
            self?.divorcedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.divorcedBtn.layer.borderWidth = 2
            
            self?.widowedBtn.backgroundColor = .white
            self?.widowedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.widowedBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.maritalStatus = 0
        
    }
    @IBAction func marriedBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.marriedBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.marriedBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.marriedBtn.setTitleColor(.white, for: .normal)
            self?.marriedBtn.layer.borderWidth = 0
            
            
            self?.singleBtn.backgroundColor = .white
            self?.singleBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.singleBtn.layer.borderWidth = 2
            
            
            self?.divorcedBtn.backgroundColor = .white
            self?.divorcedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.divorcedBtn.layer.borderWidth = 2
            
            self?.widowedBtn.backgroundColor = .white
            self?.widowedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.widowedBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.maritalStatus = 1
    }
    @IBAction func divorcedBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.divorcedBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.divorcedBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.divorcedBtn.setTitleColor(.white, for: .normal)
            self?.divorcedBtn.layer.borderWidth = 0
            
            
            self?.marriedBtn.backgroundColor = .white
            self?.marriedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.marriedBtn.layer.borderWidth = 2
            
            
            self?.singleBtn.backgroundColor = .white
            self?.singleBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.singleBtn.layer.borderWidth = 2
            
            self?.widowedBtn.backgroundColor = .white
            self?.widowedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.widowedBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.maritalStatus = 2
    }
    @IBAction func widowedBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.widowedBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.widowedBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.widowedBtn.setTitleColor(.white, for: .normal)
            self?.widowedBtn.layer.borderWidth = 0
            
            
            self?.marriedBtn.backgroundColor = .white
            self?.marriedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.marriedBtn.layer.borderWidth = 2
            
            
            self?.singleBtn.backgroundColor = .white
            self?.singleBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.singleBtn.layer.borderWidth = 2
            
            self?.divorcedBtn.backgroundColor = .white
            self?.divorcedBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.divorcedBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.maritalStatus = 3
    }
    
    //MARK:- About To Marry
    @IBAction func verySoonBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.verySoonBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.verySoonBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.verySoonBtn.setTitleColor(.white, for: .normal)
            self?.verySoonBtn.layer.borderWidth = 0
            
            
            self?.thisYearBtn.backgroundColor = .white
            self?.thisYearBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.thisYearBtn.layer.borderWidth = 2
            
            
            self?.nextYearBtn.backgroundColor = .white
            self?.nextYearBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.nextYearBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.aboutToMarry = 2
    }
    @IBAction func thisYearBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.thisYearBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.thisYearBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.thisYearBtn.setTitleColor(.white, for: .normal)
            self?.thisYearBtn.layer.borderWidth = 0
            
            
            self?.verySoonBtn.backgroundColor = .white
            self?.verySoonBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.verySoonBtn.layer.borderWidth = 2
            
            
            self?.nextYearBtn.backgroundColor = .white
            self?.nextYearBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.nextYearBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.aboutToMarry = 0
    }
    @IBAction func nextYearBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.nextYearBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.nextYearBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.nextYearBtn.setTitleColor(.white, for: .normal)
            self?.nextYearBtn.layer.borderWidth = 0
            
            
            self?.verySoonBtn.backgroundColor = .white
            self?.verySoonBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.verySoonBtn.layer.borderWidth = 2
            
            
            self?.thisYearBtn.backgroundColor = .white
            self?.thisYearBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.thisYearBtn.layer.borderWidth = 2
            
        }, completion: nil)
        filterModel.aboutToMarry = 1
    }
    
    //MARK:- Smoking
    
    @IBAction func regularlyBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.regularlyBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.regularlyBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.regularlyBtn.setTitleColor(.white, for: .normal)
            self?.regularlyBtn.layer.borderWidth = 0
            
            
            self?.occasionallyBtn.backgroundColor = .white
            self?.occasionallyBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.occasionallyBtn.layer.borderWidth = 2
            
            
            self?.neverBtn.backgroundColor = .white
            self?.neverBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.neverBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.smoking = 0
    }
    @IBAction func occasionallyBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.occasionallyBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.occasionallyBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.occasionallyBtn.setTitleColor(.white, for: .normal)
            self?.occasionallyBtn.layer.borderWidth = 0
            
            
            self?.regularlyBtn.backgroundColor = .white
            self?.regularlyBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.regularlyBtn.layer.borderWidth = 2
            
            
            self?.neverBtn.backgroundColor = .white
            self?.neverBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.neverBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.smoking = 1
    }
    @IBAction func neverBtnTapped(_ sender: UIButton) {
        UIView.transition(with: self.neverBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.neverBtn.backgroundColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0)
            self?.neverBtn.setTitleColor(.white, for: .normal)
            self?.neverBtn.layer.borderWidth = 0
            
            
            self?.occasionallyBtn.backgroundColor = .white
            self?.occasionallyBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.occasionallyBtn.layer.borderWidth = 2
            
            
            self?.regularlyBtn.backgroundColor = .white
            self?.regularlyBtn.setTitleColor(UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0), for: .normal)
            self?.regularlyBtn.layer.borderWidth = 2
            
        }, completion: nil)
        
        filterModel.smoking = 2
    }
    
    
}

//MARK:- Lifecycle
extension FiltersVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        educationTableView.delegate = self
        educationTableView.dataSource = self
        personalAttrTableView.delegate = self
        personalAttrTableView.dataSource = self
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        
        filterModel.email = self.user?.email ?? ""
    }
}

//MARK:- Interface Setup
extension FiltersVC{
    func setupInterface(){
        payerCamelLabels.names = ["Never", "Sometimes", "Usually", "Always"]
        prayerSlider.ticksListener = payerCamelLabels
        personalAttrTableView.separatorStyle = .none
        incomeTableView.separatorStyle = .none
        educationTableView.separatorStyle = .none
        heightRangeSlider.numberFormatter = HeightFormatter()
    }
}

//MARK:- TableView Datasource and Delegates
extension FiltersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == personalAttrTableView{
            return dressOptions.count
        }
        if tableView == incomeTableView{
            return incomeOptions.count
        }
        if tableView == educationTableView{
            return educationOptions.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == personalAttrTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "personal_cell") as! DressTableViewCell
            
            cell.title_lbl.text = dressOptions[indexPath.row]
            
            return cell
        }
        if tableView == incomeTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "income_cell") as! IncomeTableViewCell
            cell.title_lbl.text = incomeOptions[indexPath.row]
            return cell
        }
        if tableView == educationTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "education_cell") as! EducationTableViewCell
            
            cell.title_lbl.text = educationOptions[indexPath.row]
            
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == personalAttrTableView{
            if self.personalAttrLastSelection != nil{
                tableView.cellForRow(at: self.personalAttrLastSelection)?.accessoryType = .none
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.personalAttrLastSelection = indexPath
            
            if dressOptions[indexPath.row] == "Modest"{
                filterModel.personalAttr = 0
            }
            if dressOptions[indexPath.row] == "Hijab"{
                filterModel.personalAttr = 1
            }
            if dressOptions[indexPath.row] == "Niqab"{
                filterModel.personalAttr = 2
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if tableView == incomeTableView{
            if self.incomeLastSelection != nil{
                tableView.cellForRow(at: self.incomeLastSelection)?.accessoryType = .none
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.incomeLastSelection = indexPath
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if tableView == educationTableView{
            if self.educationLastSelection != nil{
                tableView.cellForRow(at: self.educationLastSelection)?.accessoryType = .none
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.educationLastSelection = indexPath
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
}



class HeightFormatter : NumberFormatter{
    override func string(from number: NSNumber) -> String? {
        let feet = number.int32Value/12
        let inches = number.int32Value % 12

        let height = "\(feet)"+"'"+"\(inches)"+"\""
        return height
    }
}
