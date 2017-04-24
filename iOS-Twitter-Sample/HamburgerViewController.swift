//
//  HamburgerViewController.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/21/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var originalLeftMargin: CGFloat!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    static let instance = HamburgerViewController()
    
    var contentViewController: UIViewController! {
        didSet (oldContentViewController) {
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            contentViewController.willMove(toParentViewController: self)
            contentView.layoutIfNeeded()
            contentView.addSubview(contentViewController.view)
            UIView.animate(withDuration: 0.4) { 
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }

        }
    }
    var menuViewController: UIViewController! {
        didSet {
            print("nobody set me yet")
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended{
            
            UIView.animate(withDuration: 0.4, animations: {
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 100
                }else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
           
            
        }
    }
    
    func testFunction(){
        print("iam here")
        print(self.view.frame.size.width)
        leftMarginConstraint.constant = self.view.frame.size.width - 100
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
