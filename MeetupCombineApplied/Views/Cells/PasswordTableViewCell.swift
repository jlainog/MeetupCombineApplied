//
//  PasswordTableViewCell.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/12/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: LoginUIKitViewModel?, withIndexPath indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let viewModel = viewModel {
                self.passwordTextField.text = viewModel.password
            } else {
                self.passwordTextField.text = ""
            }
            self.passwordTextField.placeholder = "Password"
        } else {
            if let viewModel = viewModel {
                self.passwordTextField.text = viewModel.passwordAgain
            } else {
                self.passwordTextField.text = ""
            }
            self.passwordTextField.placeholder = "Password again"
        }
        
    }
}
