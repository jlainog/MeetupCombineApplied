//
//  NameTableViewCell.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/12/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mailTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: LoginUIKitViewModel?) {
        if let viewModel = viewModel {
            self.mailTextField.text = viewModel.mail
        } else {
            self.mailTextField.text = ""
        }
        self.mailTextField.placeholder = "Email"
    }
}
