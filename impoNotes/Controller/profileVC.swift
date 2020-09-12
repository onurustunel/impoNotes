//
//  profileVC.swift
//  impoNotes
//
//  Created by MEHMET ONUR ÜSTÜNEL on 1.09.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase

class profileVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    @IBOutlet weak var profileTableView: UITableView!
    var firebaseUsermailArray = [String]()
    var firebaseUsernameArray = [String]()
    var FirebaseprofileImageArray = [String]()
    var bookcontentArray = [String]()
    var bookNameArray = [String]()
    var uuidArray = [String]()
    var dateArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
         self.hideKeyboardWhenTappedAround()
        
        getProfileDatafromFirebase()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookcontentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = profileTableView.dequeueReusableCell(withIdentifier: "profileCell") as! profileTVC
        
        profileCell.bookContent.text = bookcontentArray[indexPath.row]
        profileCell.usernameLabel.text = firebaseUsernameArray[indexPath.row]
        profileCell.profileImage.sd_setImage(with: URL(string: self.FirebaseprofileImageArray[indexPath.row]))
        profileCell.bookNameLabel.text = bookNameArray[indexPath.row]
        
        return profileCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func getProfileDatafromFirebase(){
        
        let fireStoreDatabase = Firestore.firestore()
        let profilName = Auth.auth().currentUser?.email
        
        fireStoreDatabase.collection("Posts").whereField("email", isEqualTo: profilName).order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("burada patlıyor")
                
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.firebaseUsermailArray.removeAll(keepingCapacity: false)
                    self.firebaseUsernameArray.removeAll(keepingCapacity: false)
                    self.FirebaseprofileImageArray.removeAll(keepingCapacity: false)
                    self.bookcontentArray.removeAll(keepingCapacity: false)
                    self.bookNameArray.removeAll(keepingCapacity: false)
                    self.uuidArray.removeAll(keepingCapacity: false)
                    self.dateArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        if let booknameInfo = document.get("bookname") as? String {
                            self.bookNameArray.append(booknameInfo)
                        }
                        
                        if let dateInfo = document.get("date") as? String {
                            self.dateArray.append(dateInfo)
                        }
                        if let emailInfo = document.get("email") as? String {
                            self.firebaseUsermailArray.append(emailInfo)
                        }
                        //
                        if let imageUrlInfo = document.get("imageUrl") as? String {
                            self.FirebaseprofileImageArray.append(imageUrlInfo)
                        }
                        if let underlinedareaInfo = document.get("underlinedarea") as? String {
                            self.bookcontentArray.append(underlinedareaInfo)
                        }
                        //
                        if let usernameInfo = document.get("username") as? String {
                            self.firebaseUsernameArray.append(usernameInfo)
                        }
                        if let uuidInfo = document.get("uuid") as? String {
                            self.uuidArray.append(uuidInfo)
                        }
                        
                    }
                    self.profileTableView.reloadData()
                    
                }
            }
        }
    }

    @IBAction func logoutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
            
        } catch {
            print("error")
        }
    }
    
}
