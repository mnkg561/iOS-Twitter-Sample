//
//  NewTweetViewController.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/15/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import AFNetworking

class NewTweetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var editableText: UITextField!
    
    let keyboardToolbar = UIToolbar()
    var label: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableText.delegate = self
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "currentUser") as? Data
        
        if let userData = userData {
            let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
            let user = User(dictionary: dictionary)
            print(user.name!)
        
        userProfileImageView.setImageWith(user.profileURL!)
        }
        // Do any additional setup after loading the view.
        
        
        //let keyboardToolbar = UIToolbar()
        self.keyboardToolbar.sizeToFit()
        self.keyboardToolbar.isTranslucent = false
        self.keyboardToolbar.barTintColor = UIColor.white

        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        self.label.text = "140"
       
   
        editableText.becomeFirstResponder()
        
        displayBarButton(buttonName: "Tweet-button", buttonFlag: false)
        
        
    }

    func tweetButtonClicked (){
        let message: String = editableText.text!
        print(message)
        TwitterOAuth1Client.sharedInstance?.sendNewTweet(newTweetText: message)
        editableText.text = nil
        self.label.text = "140"
        displayBarButton(buttonName: "Tweet-button", buttonFlag: false)
    }
    
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.utf16.count)! + (string.utf16.count) - range.length

        if(newLength <= 140){
            self.label.text = "\(140 - newLength)"
            displayBarButton(buttonName: "Tweet-button-filled", buttonFlag: true)
            if newLength == 0 {
                displayBarButton(buttonName: "Tweet-button", buttonFlag: false)
            }
            
            return true
        }else{
            return false
        }
    }
    
    // display UIKeyboard tool bar items
    func displayBarButton(buttonName: String,  buttonFlag: Bool){
         let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil);
        
        let test = UIBarButtonItem(title: self.label.text, style: .plain, target: nil, action: nil)
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: buttonName), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        if buttonFlag == true {
           
            btn1.addTarget(self, action: #selector(self.tweetButtonClicked), for: .touchDown)
        }
        
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.keyboardToolbar.items = [flexibleSpace, test, item1]
        editableText.inputAccessoryView = keyboardToolbar
        
        

    }
    
    func keyboardButton(){
        print("yo")
    }
   
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true) {
            print("cancel button clicked")
        }
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
