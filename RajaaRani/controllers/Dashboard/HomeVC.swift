//
//  HomeVC.swift
//  RajaaRani
//

//

import UIKit
import Shuffle_iOS

class HomeVC: UIViewController {

    //MARK:- Properties
    let cardImages = [
        UIImage(named: "placeholder-card"),
        UIImage(named: "placeholder-card"),
        UIImage(named: "placeholder-card")
    ]
    
    var cardExpanded = false
    
    //MARK:- Outlets
    
    @IBOutlet weak var centreBtns_stackView: UIStackView!
    
    @IBOutlet weak var top_cardView: UIView!
    
    @IBOutlet weak var bottom_cardView: UIView!
    
    @IBOutlet weak var profileCard_img: UIImageView!
    
    @IBOutlet weak var card_main: UIView!
    
    
    
    
    //MARK:- Constraints
    
    @IBOutlet weak var bottomCard_heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomCard_botConstraint: NSLayoutConstraint!
    
    
    //MARK:- Actions
    
    
   


}


//MARK:- Event Handlers
extension HomeVC{
    
    @objc func topViewTapped(_ sender: UITapGestureRecognizer? = nil){
        if cardExpanded{
            self.bottomCard_heightConstraint.constant -= 180
            self.cardExpanded = false
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func bottomViewTapped(_ sender: UITapGestureRecognizer? = nil) {
        
        if !cardExpanded{
            self.bottomCard_heightConstraint.constant += 180
            self.cardExpanded = true
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
}


//MARK:- Lifecycle
extension HomeVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        
        
    }
}

//MARK:- Interface Setup
extension HomeVC{
    func setupInterface(){
        
        top_cardView.roundCorners([.allCorners], radius: 55)
        bottom_cardView.roundCorners([.topLeft, .topRight], radius: 55)
        top_cardView.setCardView()
        bottom_cardView.setCardView()
        profileCard_img.layer.cornerRadius = 55
        
        //tap gestures
        let tapBot = UITapGestureRecognizer(target: self, action: #selector(self.bottomViewTapped(_:)))
        bottom_cardView.addGestureRecognizer(tapBot)
        
        let tapTop = UITapGestureRecognizer(target: self, action: #selector(self.topViewTapped(_:)))
        top_cardView.addGestureRecognizer(tapTop)
        
        let cardStack = SwipeCardStack()
          
          
        
        card_main.addSubview(cardStack)
        cardStack.frame = card_main.safeAreaLayoutGuide.layoutFrame
        cardStack.dataSource = self

        
    }
    
    
    func card(fromImage image: UIImage) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.content = UIImageView(image: image)
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .green

        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .red

        card.setOverlays([.left: leftOverlay, .right: rightOverlay])

        return card
    }
    
    
}

//MARK:- Card stack delegates
extension HomeVC: SwipeCardStackDataSource{
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return card(fromImage: cardImages[index]!)
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardImages.count
    }
    
    
}


//MARK:- Helpers
extension HomeVC{
    
}



