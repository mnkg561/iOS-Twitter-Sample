//
//  ReplyTableViewController.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/16/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class ReplyTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var editableText: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var userProfilePicImageView: UIImageView!
    
    let keyboardToolbar = UIToolbar()
    var label: UILabel!
    var tweetId: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableText.delegate = self
        
        
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "currentUser") as? Data
        
        if let userData = userData {
            let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
            let user = User(dictionary: dictionary)
            print(user.name!)
            
            userProfilePicImageView.setImageWith(user.profileURL!)
        }

        
        
        
        self.keyboardToolbar.sizeToFit()
        self.keyboardToolbar.isTranslucent = false
        self.keyboardToolbar.barTintColor = UIColor.white
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        self.label.text = "140"
        
        editableText.becomeFirstResponder()
        
        displayBarButton(buttonName: "Reply-button", buttonFlag: false)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickCancelButton(_ sender: Any) {
        
        
        self.dismiss(animated: true) {
            print("cancel button clicked")
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.utf16.count)! + (string.utf16.count) - range.length
        
        if(newLength <= 140){
            self.label.text = "\(140 - newLength)"
            displayBarButton(buttonName: "Reply-button-filled", buttonFlag: true)
            if newLength == 0 {
                displayBarButton(buttonName: "Reply-button", buttonFlag: false)
            }
            
            return true
        }else{
            return false
        }

    }
    // display UIKeyboard tool bar items
    func displayBarButton(buttonName: String,  buttonFlag: Bool){
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil);
        
        let labelBar = UIBarButtonItem(title: self.label.text, style: .plain, target: nil, action: nil)
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: buttonName), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        if buttonFlag == true {
            
            btn1.addTarget(self, action: #selector(self.replyButtonClicked), for: .touchDown)
        }
        
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.keyboardToolbar.items = [flexibleSpace, labelBar, item1]
        editableText.inputAccessoryView = keyboardToolbar
        
        
        
    }
    
    func replyButtonClicked(){
        print("somebody clicked me ")
        print(self.tweetId)
        
        let message: String = userNameLabel.text! + " " + editableText.text!
        print(message)
        TwitterOAuth1Client.sharedInstance?.replyToTweet(replyTweetText: message, tweetId: self.tweetId)
        editableText.text = nil
        self.label.text = "140"
        displayBarButton(buttonName: "Reply-button", buttonFlag: false)
        
        
    }


  
}
