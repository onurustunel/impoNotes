//
//  signUpVC.swift
//  impoNotes
//
//  Created by MEHMET ONUR ÜSTÜNEL on 1.09.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase


class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
      
        profileImage.isUserInteractionEnabled = true
        let imagePickerRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePick))
        profileImage.addGestureRecognizer(imagePickerRecognizer)
         self.hideKeyboardWhenTappedAround()
        
    }
    
    @objc func imagePick(){
       
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        picker.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != ""  && usernameText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
            if error != nil {
                 Alert.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error", vc: self)
                
                }
                else {
                
                let storage = Storage.storage()
                let storageReference = storage.reference()
                
                let mediaFolder = storageReference.child("media")
                if let data = self.profileImage.image?.jpegData(compressionQuality: 0.5) {
                let uuid = UUID().uuidString
                let imageReferance = mediaFolder.child("\(uuid).jpg")
                   imageReferance.putData(data, metadata: nil) { (metadata, error) in
                        //code
                        if error != nil {
                            print("error")
                            
                        } else {
                            imageReferance.downloadURL { (url, error) in
                                
                                if error == nil {
                                    
                                    let imageUrl = url?.absoluteString
                                   
                                    //DATABASE
                                     let firestoreDatabase = Firestore.firestore()
                                    
                                    var firestoreReference : DocumentReference? = nil
                                    
                                    let firestorePost = ["imageUrl" : imageUrl!, "email" : self.emailText.text!, "username" : self.usernameText.text!, "date" : FieldValue.serverTimestamp(), "uuid" : uuid ] as [String : Any]
                                   firestoreReference = firestoreDatabase.collection("Users").addDocument(data: firestorePost, completion: { (error) in
                                        if error != nil {
                                            print("error")
                                            
                                        } else {
                                        }
                                        
                                    })
                                }
                            }
                        }
                    }
                }
                
                    self.performSegue(withIdentifier: "fromSignUptoFeedVC", sender: nil)
                }
            }
        }
            
        else {
            Alert.makeAlert(titleInput: "ERROR", messageInput: "There is a problem!" , vc: self)
        }
        
    }

}
