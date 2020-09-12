//
//  ViewController.swift
//  impoNotes
//
//  Created by MEHMET ONUR ÜSTÜNEL on 1.09.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase

class signIn: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.hideKeyboardWhenTappedAround()
    }
    @IBAction func signInClicked(_ sender: Any) {
         Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
             if error != nil {
               Alert.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error", vc: self)
            } else {
                
                if self.emailText.text != nil && self.passwordText.text != nil {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
                else {
                     Alert.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error", vc: self)
                }
            }
        }
        
    }
   
}

