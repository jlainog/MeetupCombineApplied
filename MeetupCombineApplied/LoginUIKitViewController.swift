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

class LoginUIKitViewController: UIViewController {
    
    private let cellNameIdentifier = "nameCell"
    private let cellPasswordIdentifier = "passwordCell"
    private let cellContinueButtonIdentifier = "continueButtonCell"
    
    private var viewModel: LoginUIKitViewModel = .init()
    
    @IBOutlet weak var loginTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loginTableView.delegate = self
        self.loginTableView.dataSource = self
    }
}

extension LoginUIKitViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nameCell = loginTableView.dequeueReusableCell(withIdentifier: cellNameIdentifier,
                                                          for: indexPath) as! NameTableViewCell
        
        let passwordCell = loginTableView.dequeueReusableCell(withIdentifier: cellPasswordIdentifier,
                                                              for: indexPath) as! PasswordTableViewCell
        
        let continueButtonCell = loginTableView.dequeueReusableCell(withIdentifier: cellContinueButtonIdentifier,
                                                                    for: indexPath) as! ContinueButtonTableViewCell
        
        switch indexPath.section {
        case 0:
            nameCell.configure(with: viewModel)
            return nameCell
        case 1:
            passwordCell.configure(with: viewModel, withIndexPath: indexPath)
            return passwordCell
        default:
            continueButtonCell.configure(with: viewModel)
            return continueButtonCell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return viewModel.mailMessage
        } else if section == 1 {
            return viewModel.passwordMessage
        } else {
            return " "
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
}

extension LoginUIKitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
