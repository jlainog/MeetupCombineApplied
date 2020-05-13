//
//  ContinueButtonTableViewCell.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/12/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import UIKit

class ContinueButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var continueButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: LoginUIKitViewModel?) {
        self.continueButton.titleLabel?.text = "Continue"
        self.continueButton.isEnabled = viewModel?.enabledContinue ?? false
    }
}
