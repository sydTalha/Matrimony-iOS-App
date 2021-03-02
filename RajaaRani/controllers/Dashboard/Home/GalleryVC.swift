//
//  GalleryVC.swift
//  RajaaRani
//

//

import UIKit
import FSPagerView
import AVFoundation

class GalleryVC: UIViewController {

    //MARK:- Properties
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    var looper: AVPlayerLooper?
    

    let scrollView = UIScrollView()
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl : UIPageControl = UIPageControl()

    
    //MARK:- Outlets
    
    

    //MARK:- Actions
    
    
    
    //MARK:- Event Handlers
//    @objc private func pageControlDidChanged(_ sender: UIPageControl){
//        let current = sender.currentPage
//        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
//    }
}

//MARK:- Lifecycle
extension GalleryVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setupInterface()
        self.scrollView.frame = self.view.frame
        self.pageControl.frame = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 50, width:200, height:50)
        configurePageControl()

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        self.view.addSubview(scrollView)
        for index in 0..<3 {

            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size

            let subView = UIView(frame: frame)
            subView.backgroundColor = colors[index]
            self.scrollView.addSubview(subView)
        }

        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 4,height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
        
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
    }
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)

    }
    
    

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        pageControl.frame = CGRect(x: 10, y: view.frame.size.height - 100, width: view.frame.size.width - 20, height: 70)
//
//        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 100)
//
//        if scrollView.subviews.count == 2{
//            configureScrollView()
//        }
    }
    
}


//MARK:- Interface Setup
extension GalleryVC{
//    func setupInterface(){
//        scrollView.backgroundColor = .systemRed
//        view.addSubview(pageControl)
//        view.addSubview(scrollView)
//        scrollView.delegate = self
//        pageControl.addTarget(self, action: #selector(pageControlDidChanged(_:)), for: .valueChanged)
//    }
    
//    private func configureScrollView(){
//        scrollView.contentSize = CGSize(width: view.frame.size.width * 5, height: scrollView.frame.height)
//        scrollView.isPagingEnabled = true
//
//        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemPink]
//        for x in 0..<3{
//            print("page added")
//            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height))
//            page.backgroundColor = colors[x]
//            scrollView.addSubview(page)
//        }
//    }
}


//MARK:- ScrollView Delegate
extension GalleryVC: UIScrollViewDelegate{
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
//
//
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}

//MARK:- Helpers
extension GalleryVC{
    func playVideo(videoLayer: UIView){
        guard let path = Bundle.main.path(forResource: "intro", ofType: "mp4") else{
            return
        }
        
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        let playerItem = AVPlayerItem(asset: asset)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: queuePlayer)
        looper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        
        playerLayer!.frame = videoLayer.bounds
        playerLayer!.videoGravity = .resizeAspectFill
        
        videoLayer.cornerRadius = 13
        videoLayer.layer.addSublayer(playerLayer!)
        queuePlayer?.play()
        
        //allViewsToFront()
    }
}
