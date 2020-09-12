//
//  profileTVC.swift
//  impoNotes
//
//  Created by MEHMET ONUR ÜSTÜNEL on 8.09.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit

class profileTVC: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bookContent: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = {
            let view = UIView.init()
            view.backgroundColor = .black
            return view
        }()
        //  @IBOutlet weak var bookNameLabel: UILabel!   
       // @IBOutlet weak var bookContent: UILabel!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
