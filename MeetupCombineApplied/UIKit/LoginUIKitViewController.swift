//
//  LoginUIKitViewController.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/11/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import UIKit

final class LoginUIKitViewModel {
    var mail: String = "" {
        didSet {
            updateUI()
        }
    }
    var password: String = "" {
        didSet {
            updateUI()
        }
    }
    var passwordAgain: String = "" {
        didSet {
            updateUI()
        }
    }
    
    var mailMessage: String = "Your mail should be longer than 3 characters"
    var passwordMessage: String = "Validate your passwords are equal and contains at leats 6 characters"
    var enabledContinue: Bool = false
    
    var reloadEmailFooter: ((String) -> Void)?
    var reloadPasswordFooter: ((String) -> Void)?
    
    func updateUI() {
        mailMessage = isValidUserName ? "" : "Your mail should be longer than 3 characters"
        passwordMessage = isPasswordValid ? "" : "Validate your passwords are equal and contains at leats 6 characters"
        enabledContinue = isLoginInfoValid
        reloadEmailFooter?(mailMessage)
        reloadPasswordFooter?(passwordMessage)
    }
    
    var isValidUserName: Bool {
        mail.count > 6
    }
    
    var isPasswordNotEmpty: Bool {
        !password.isEmpty
    }
    
    var arePasswordEqual: Bool {
        password == passwordAgain
    }
    
    var isPasswordStrong: Bool {
        password.count >= 6
    }
    
    var isPasswordValid: Bool {
        isPasswordNotEmpty && arePasswordEqual && isPasswordStrong
    }
    
    var isLoginInfoValid: Bool {
        isValidUserName && isPasswordValid
    }
}

class LoginUIKitViewController: UITableViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    private var viewModel: LoginUIKitViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadEmailFooter = { [weak self] text in
            self?.tableView.beginUpdates()
            let emailfooter = self?.tableView.footerView(forSection: 0)
            emailfooter?.textLabel?.text = text
            emailfooter?.textLabel?.textColor = .red
            self?.tableView.endUpdates()
        }
        viewModel.reloadPasswordFooter = { [weak self] text in
            self?.tableView.beginUpdates()
            let passwordfooter = self?.tableView.footerView(forSection: 1)
            passwordfooter?.textLabel?.text = text
            passwordfooter?.textLabel?.textColor = .red
            self?.tableView.endUpdates()
        }
        
        NotificationCenter.default.addObserver(
            forName: UITextField.textDidChangeNotification,
                                               object: nil,
                                               queue: nil
        ) { [weak self] (notification) in
            guard let textField = notification.object as? UITextField else { return }
            
            switch textField {
                case self?.emailTextField:
                    self?.viewModel.mail = self?.emailTextField.text ?? ""
                
                case self?.passwordTextField:
                    self?.viewModel.password = self?.passwordTextField.text ?? ""
                
                case self?.passwordAgainTextField:
                    self?.viewModel.passwordAgain = self?.passwordAgainTextField.text ?? ""
                
                default: break
            }
        }
    }
    
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
        
        
        
        return true
    }
}
