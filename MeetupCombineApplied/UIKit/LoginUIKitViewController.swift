//
//  LoginUIKitViewController.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/11/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import UIKit
import Combine

class LoginUIKitViewController: UITableViewController {
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    private var viewModel: LoginViewModel = .init()
    
    private func reloadUI() {
        self.tableView.beginUpdates()
        let emailfooter = tableView.footerView(forSection: 0)
        emailfooter?.textLabel?.text = viewModel.mailMessage
        emailfooter?.textLabel?.textColor = .red
        
        let passwordfooter = tableView.footerView(forSection: 1)
        passwordfooter?.textLabel?.text = self.viewModel.passwordMessage
        passwordfooter?.textLabel?.textColor = .red
        
        self.continueButton.isEnabled = self.viewModel.enabledContinue
        self.tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.objectWillChange
            .sink(receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.reloadUI()
                }
            }).store(in: &cancellables)
 
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nil).sink { [weak self] notification in
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
        }.store(in: &cancellables)
    }
}
