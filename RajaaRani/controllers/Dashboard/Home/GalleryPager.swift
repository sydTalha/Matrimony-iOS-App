//
//  GalleryPager.swift
//  RajaaRani
//

//

import UIKit

class GalleryPager: UIPageViewController {

    //MARK:- Properties
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var pages: [Pages] = Pages.allCases
    //MARK:- Outlets
    
    
    //MARK:- Actions
    
    

}

//MARK:- Pages Enum
enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    
    var name: String {
        switch self {
        case .pageZero:
            return "This is page zero"
        case .pageOne:
            return "This is page one"
        case .pageTwo:
            return "This is page two"
        case .pageThree:
            return "This is page three"
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        }
    }
}

//MARK:- Lifecycle
extension GalleryPager{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
}

//MARK:- Interface Setup
extension GalleryPager{
    func setupInterface(){
        currentIndex = 0
        setupPageController()
    }
    
    private func setupPageController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        
        let initialVC = PageVC(with: pages[0])
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParent: self)
        
        self.pageController?.didMove(toParent: self)
    }
}

//MARK:- UIPageViewController Delegate
extension GalleryPager: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let currentVC = viewController as? PageVC else {
                return nil
            }
                
            var index = currentVC.page.index
            
            if index >= self.pages.count - 1 {
                return nil
            }
            
            index += 1
            
            let vc: PageVC = PageVC(with: pages[index])
            
            return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let currentVC = viewController as? PageVC else {
                return nil
            }
            
            var index = currentVC.page.index
            
            if index == 0 {
                return nil
            }
            
            index -= 1
            
            let vc: PageVC = PageVC(with: pages[index])
            
            return vc
        }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
}

//MARK:- Helpers
extension GalleryPager{
    
}


//MARK:- Single Page
class PageVC: UIViewController {
    
    var titleLabel: UILabel?
    
    var page: Pages
    
    init(with page: Pages) {
        self.page = page
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        titleLabel?.center = CGPoint(x: 160, y: 250)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.text = page.name
        self.view.addSubview(titleLabel!)
        self.view.backgroundColor = .blue
    }
}

