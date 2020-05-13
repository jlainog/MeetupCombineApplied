//
//  LoginUIKitViewController.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/11/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import UIKit

final class LoginUIKitViewModel {
  var mail: String = ""
  var password: String = ""
  var passwordAgain: String = ""
  
  var mailMessage: String = "Your mail should be longer than 3 characters"
  var passwordMessage: String = "Validate your passwords are equal and contains at leats 6 characters"
  var enabledContinue: Bool = false
  
  init() {
//    isLoginInfoValidPublisher
//      .receive(on: RunLoop.main)
//      .assign(to: \.enabledContinue, on: self)
//      .store(in: &cancellable)
//
//    isValidUserNamePublisher
//      .receive(on: RunLoop.main)
//      .map { $0 ? "" : "Your mail should be longer than 3 characters" }
//      .assign(to: \.mailMessage, on: self)
//      .store(in: &cancellable)
//
//    isPasswordValidPublisher
//      .receive(on: RunLoop.main)
//      .map { $0 ? "" : "Validate your passwords are equal and contains at leats 6 characters" }
//      .assign(to: \.passwordMessage, on: self)
//      .store(in: &cancellable)
  }
}

class LoginUIKitViewController: UITableViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    private var viewModel: LoginUIKitViewModel = .init()
    
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return viewModel.mailMessage
        } else if section == 1 {
            return viewModel.passwordMessage
        } else {
            return " "
        }
    }
}

extension LoginUIKitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        switch textField {
            case emailTextField:
                viewModel.mail = textField.text ?? ""
            
            case passwordTextField:
                viewModel.password = textField.text ?? ""
            
            case passwordAgainTextField:
                viewModel.passwordAgain = textField.text ?? ""
            
            default: break
        }
        
        return true
    }
}
