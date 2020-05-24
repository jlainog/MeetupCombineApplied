//
//  LoginUIKitViewController.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/11/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import UIKit
import Combine
import ComposableArchitecture

class LoginUIKitViewController: UITableViewController {
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    let viewStore: ViewStore<LoginState, LoginAction>
    
    required init?(coder: NSCoder) {
        let deletate = UIApplication.shared.delegate as! AppDelegate
        self.viewStore = ViewStore(deletate.store)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewStore.publisher
            .email
            .assign(to: \.text!, on: emailTextField)
            .store(in: &cancellables)
        viewStore.publisher
            .password
            .assign(to: \.text!, on: passwordTextField)
            .store(in: &cancellables)
        viewStore.publisher
            .passwordAgain
            .assign(to: \.text!, on: passwordAgainTextField)
            .store(in: &cancellables)
        
        viewStore.publisher
            .emailMessage
            .sink {
                self.tableView.beginUpdates()
                let emailfooter = self.tableView.footerView(forSection: 0)
                emailfooter?.textLabel?.textColor = .red
                emailfooter?.textLabel?.text = $0
                self.tableView.endUpdates()
            }
            .store(in: &cancellables)
        
        viewStore.publisher
            .passwordMessage
            .sink {
                self.tableView.beginUpdates()
                let passwordfooter = self.tableView.footerView(forSection: 1)
                passwordfooter?.textLabel?.textColor = .red
                passwordfooter?.textLabel?.text = $0
                self.tableView.endUpdates()
            }
            .store(in: &cancellables)
        
        Publishers
            .CombineLatest(viewStore.publisher.hasValidEmail,
                           viewStore.publisher.hasValidPassword)
            .sink {
                self.tableView.beginUpdates()
                self.continueButton.isEnabled = $0 && $1
                self.tableView.endUpdates()
        }
        .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nil).sink { [weak self] notification in
            guard let textField = notification.object as? UITextField else { return }
            
            switch textField {
            case self?.emailTextField:
                self?.viewStore.send(.emailTextChanged(self?.emailTextField.text ?? ""))
                
            case self?.passwordTextField:
                self?.viewStore.send(.passwordChanged(self?.passwordTextField.text ?? ""))
                
            case self?.passwordAgainTextField:
                self?.viewStore.send(.passwordAgainChanged(self?.passwordAgainTextField.text ?? ""))
                
            default: break
            }
        }.store(in: &cancellables)

    }
    
}
