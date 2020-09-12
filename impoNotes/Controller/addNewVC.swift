//
//  addNewVC.swift
//  impoNotes
//
//  Created by MEHMET ONUR ÜSTÜNEL on 1.09.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase

class addNewVC: UIViewController {
    
    @IBOutlet weak var bookNameLabel: UITextField!
    @IBOutlet weak var underlinedAreaLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
         // Do any additional setup after loading the view.
    }
   
     @IBAction func shareClicked(_ sender: Any) {
         //DATABASE
         let uuid = UUID().uuidString
         let firestoreDatabase = Firestore.firestore()
                            
         var firestoreReference : DocumentReference? = nil
                            
        let firestorePost = ["imageUrl" : sendProfileImage, "bookname" : bookNameLabel.text!,"underlinedarea" : underlinedAreaLabel.text, "email" : sendUsermail, "username" : sendUsername, "date" : FieldValue.serverTimestamp(), "uuid" : uuid ] as [String : Any]
          firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
          if error != nil {
            print("error while uploading the data")
                                    
             } else {
            self.bookNameLabel.text = ""
            self.underlinedAreaLabel.text = ""
            self.tabBarController?.selectedIndex = 0
            }
           })
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

