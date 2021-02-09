//
//  Extensions.swift
//  RajaaRani
//

//

import Foundation
import UIKit
import MapKit

//MARK:- UIViews
extension UIView {

    //MARK:- IBInspectables
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    //MARK:- Other Extensions
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func setCardView(){
        //layer.cornerRadius = 55
        layer.masksToBounds = true

        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        layer.shadowRadius = 15.0
        layer.masksToBounds = false
    }
    
    func setSmallShadow(){
        //layer.cornerRadius = 55
        layer.masksToBounds = true

        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
    }
    
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    
}

//MARK:- UIViewControllers
extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK:- UINavigationController
extension UINavigationController{
    override public func viewDidLoad() {
            super.viewDidLoad()
            interactivePopGestureRecognizer?.delegate = nil
        }
}



//MARK:- Textfields
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


//MARK:- CLLocation
extension CLLocation{
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) {
            completion($0?.first?.locality, $0?.first?.country, $1)
        }
    }
}

//MARK:- UIColor
extension UIColor {
  convenience init(hex: String) {
    var hex = hex
    if hex.hasPrefix("#") {
        hex.remove(at: hex.startIndex)
    }
    
    var rgb: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&rgb)

    let r = (rgb & 0xff0000) >> 16
    let g = (rgb & 0xff00) >> 8
    let b = rgb & 0xff
    
    self.init(
      red: CGFloat(r) / 0xff,
      green: CGFloat(g) / 0xff,
      blue: CGFloat(b) / 0xff,
      alpha: 1
    )
  }
  
  var hexString: String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    self.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return String(
      format: "#%02X%02X%02X",
      Int(r * 0xff),
      Int(g * 0xff),
      Int(b * 0xff)
    )
  }
}

//MARK:- String
extension String {
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else {
            return 0
        }

        var interval:Double = 0

        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }

        return interval
    }
    
    
    func splitStringInHalf()->(firstHalf:String,secondHalf:String) {
        let words = self.components(separatedBy: " ")
        let halfLength = words.count / 2
        let firstHalf = words[0..<halfLength].joined(separator: " ")
        let secondHalf = words[halfLength..<words.count].joined(separator: " ")
        return (firstHalf:firstHalf,secondHalf:secondHalf)
    }
    
    
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }

    
}

//MARK:- UInt
extension UInt {
    static func parse(from string: String) -> UInt? {
        return UInt(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}


//MARK:- Notification
extension Notification.Name {
    public static let twilioDataNotificationKey = Notification.Name(rawValue: "twilioObj")
}






