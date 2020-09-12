//
//  feedVC.swift
//  impoNotes
//
//  Created by MEHMET ONUR ÜSTÜNEL on 1.09.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import CoreText
import SDWebImage
import Firebase
import FirebaseAuth
import FirebaseFirestore
// GLobal Variables
var sendUsermail = ""
var sendUsername = ""
var sendProfileImage = ""

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var feedTCTopConst: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var feedTableView: UITableView!
   
   
    var searching = false
    var filteredData: [String] = []
    var myMergedArray = [String]()
    var selectedIndex = [String]()
    // user
    var usermailArray = [String]()
    var userDateArray = [String]()
    var usernameArray = [String]()
    var userUUIDArray = [String]()
    var profileImageArray = [String]()
    var documentIdArray = [String]()
    
    // firebase Variables
    var firebaseUsermailArray = [String]()
    var firebaseUsernameArray = [String]()
    var FirebaseprofileImageArray = [String]()
    var bookcontentArray = [String]()
    var bookNameArray = [String]()
    var uuidArray = [String]()
    var dateArray = [String]()
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        feedTCTopConst.constant = 60
            searchBar.isHidden = false
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
      
        getFeedDatafromFirebase()
       
        self.hideKeyboardWhenTappedAround()
        searchBar.isHidden = true
        feedTCTopConst.constant = 0
        searchBar.delegate = self
      
        getDataFromFirestore()
      }
    
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
    
        let profilName = Auth.auth().currentUser?.email
        
        fireStoreDatabase.collection("Users").whereField("email", isEqualTo: profilName).order(by: "date", descending: true).addSnapshotListener
            { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    if snapshot?.isEmpty != true && snapshot != nil {
                        
                        self.usermailArray.removeAll(keepingCapacity: false)
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.profileImageArray.removeAll(keepingCapacity: false)
                       
                        for document in snapshot!.documents {
                            let documentID = document.documentID
                            self.documentIdArray.append(documentID)
                            
                            if let userName = document.get("username") as? String {
                                self.usernameArray.append(userName)
                            }
                            if let daTe = document.get("date") as? String {
                                self.dateArray.append(daTe)
                            }
                            
                            if let eMail = document.get("email") as? String {
                                self.usermailArray.append(eMail)
                            }
                            if let uuID = document.get("uuid") as? String {
                                self.userUUIDArray.append(uuID)
                            }
                            if let imageUrl = document.get("imageUrl") as? String {
                                self.profileImageArray.append(imageUrl)
                            }
                            
                            sendUsermail = self.usermailArray[0]
                            sendUsername = self.usernameArray[0]
                            sendProfileImage = self.profileImageArray[0]
                            
                        }
                        self.feedTableView.reloadData()
                        
                    }
                }
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return siirArray.count
        if searching {
            return filteredData.count
        } else {
            return bookcontentArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "cell") as! feedTVC
        if searching {
            feedTCTopConst.constant = 30
            cell.bookContent.text = filteredData[indexPath.row]
            cell.bookNameLabel.text = cell.bookContent.firstLineString
            cell.usernameLabel.text = "impoNotes"
            cell.profileImage.image = UIImage(named: "logo_icon")
          }
        else {
            
             cell.bookContent.text = myMergedArray[indexPath.row]
             cell.usernameLabel.text = firebaseUsernameArray[indexPath.row]
             cell.profileImage.sd_setImage(with: URL(string: self.FirebaseprofileImageArray[indexPath.row]))
             cell.bookNameLabel.text = cell.bookContent.firstLineString
        
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
extension feedVC: UISearchBarDelegate {
      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         filteredData = myMergedArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
         searching = true
        
        if searchText == "" {
            searching = false
            feedTableView.reloadData()
            filteredData.removeAll(keepingCapacity: false)
            
        }
            feedTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        searchBar.text = ""
        feedTableView.reloadData()
        filteredData.removeAll(keepingCapacity: false)
    }
    //  we will get the feed here
    func getFeedDatafromFirebase(){
        
        let fireStoreDatabase = Firestore.firestore()
        let profilName = Auth.auth().currentUser?.email
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
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
                        
                        if let imageUrlInfo = document.get("imageUrl") as? String {
                            self.FirebaseprofileImageArray.append(imageUrlInfo)
                        }
                        if let underlinedareaInfo = document.get("underlinedarea") as? String {
                            self.bookcontentArray.append(underlinedareaInfo)
                        }
                      
                        if let usernameInfo = document.get("username") as? String {
                            self.firebaseUsernameArray.append(usernameInfo)
                        }
                        if let uuidInfo = document.get("uuid") as? String {
                            self.uuidArray.append(uuidInfo)
                        }
                       
                    }
                    self.feedTableView.reloadData()
                    
                }
              
                for index in 0...self.bookcontentArray.count-1{
                    self.myMergedArray.append("\(self.bookNameArray[index])\n\(self.bookcontentArray[index])")

                }
            }
        }
    }
} //class  ends here

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
extension UILabel {
    
    /// Returns the String displayed in the first line of the UILabel or "" if text or font is missing
    var firstLineString: String {
        
        guard let text = self.text else { return "" }
        guard let font = self.font else { return "" }
        let rect = self.frame
        
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(NSAttributedString.Key(rawValue: String(kCTFontAttributeName)), value: CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil), range: NSMakeRange(0, attStr.length))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width + 7, height: 100))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        
        guard let line = (CTFrameGetLines(frame) as! [CTLine]).first else { return "" }
        let lineString = text[text.startIndex...text.index(text.startIndex, offsetBy: CTLineGetStringRange(line).length-2)]
        
        return String(lineString)
    }
}



