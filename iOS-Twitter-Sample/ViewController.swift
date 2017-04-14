//
//  ViewController.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/11/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onClickMiniTwitterButton(_ sender: Any) {
        let client = TwitterOAuth1Client.sharedInstance
        client?.redirectUserToTwitter(success: {
            print("I've logged in! ")
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error) in
            print("Error \(error)")
        })
    }
}

