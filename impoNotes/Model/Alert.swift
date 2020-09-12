//
//  GetBookName.swift
//  impoNotes
//
//  Created by MEHMET ONUR ÜSTÜNEL on 7.09.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import Foundation
import UIKit


class Alert  {
    
   static func makeAlert(titleInput: String, messageInput: String, vc: UIViewController) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        vc.present(alert, animated: true, completion: nil)
    }
    
}

