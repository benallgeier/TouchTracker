//
//  ViewController.swift
//  TouchTracker
//
//  Created by Benjamin Allgeier on 10/9/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

// challenge to allow user to pick color by swiping up
// not implemented yet

//import UIKit
//
//class ViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // configure swipe gesture to allow user to pick color
//        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(chooseColor(_:)))
//        
//        swipeUpRecognizer.direction = .up
//        swipeUpRecognizer.numberOfTouchesRequired = 3
//        
//        // without delaying, you get lines briefly while swiping up
//        // but they quickly disappear
//        // if you delay, then drawing lines up takes a noticable amount 
//        // of time before lines start showing
////        swipeUpRecognizer.delaysTouchesBegan = true
//        
//        (view as! DrawView).moveRecognizer.require(toFail: swipeUpRecognizer)
//        view.addGestureRecognizer(swipeUpRecognizer)
//
//    } // end viewDidLoad()
//    
//    func chooseColor(_ gestureRecognizer: UIGestureRecognizer) {
//        print(#function)
//        
//        // instantiate and configure a new ColorPanelViewController
//        
//        let colorPanelViewController = ColorPanelViewController()
//        colorPanelViewController.modalPresentationStyle = .overCurrentContext
//        ////////////// This is where you pick back up
//    } // end chooseColor(_:)
//    
//}
