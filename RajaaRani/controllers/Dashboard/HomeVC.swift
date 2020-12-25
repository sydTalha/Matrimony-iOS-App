//
//  HomeVC.swift
//  RajaaRani
//

//

import UIKit
import DMSwipeCards
import ZLSwipeableViewSwift
import Koloda

class HomeVC: UIViewController {

    //MARK:- Properties
    
    var cardExpanded = false
    var count = 0
    
    //MARK:- Outlets
    @IBOutlet weak var cardStack_main: KolodaView!
    
    
    //MARK:- Constraints
    
    
    //MARK:- Actions
    
    
   


}


//MARK:- Event Handlers
extension HomeVC{

    
    
}


//MARK:- Lifecycle
extension HomeVC{
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        cardStack_main.delegate = self
        cardStack_main.dataSource = self
        self.cardStack_main.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        
        
        
        
    }
}


//MARK:- Interface Setup
extension HomeVC{
    func setupInterface(){
        
    }
    
    
    
    
}



//MARK:- Kolada CardView Delegate - Datasource
extension HomeVC: KolodaViewDataSource, KolodaViewDelegate{
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let s = UIView()
        s.addSubview(ProfileCard(frame: cardStack_main.bounds))
        return s
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 8
    }
    
    
    
}


//MARK:- Helpers
extension HomeVC{
    
}



