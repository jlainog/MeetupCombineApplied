//
//  CombineViewController.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/11/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import SwiftUI
import Combine

class LoginSwiftUIViewController: UIHostingController<AnyView> {
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: AnyView(LoginFormView()))
    }
}

struct LoginFormView: View {
  @ObservedObject private var viewModel: LoginViewModel = .init()
  
  var body: some View {
    Form {
      Section(footer: Text(viewModel.mailMessage).foregroundColor(.red)) {
        TextField("Email", text: $viewModel.mail)
          .autocapitalization(.none)
      }
      Section(footer: Text(viewModel.passwordMessage).foregroundColor(.red)) {
        SecureField("Password", text: $viewModel.password)
        SecureField("Password again", text: $viewModel.passwordAgain)
      }
      Section {
        Button(action: {},
               label: { Text("Continue") })
          .disabled(!viewModel.enabledContinue)
      }
    }
  }
}

struct LoginFormView_Previews: PreviewProvider {
  static var previews: some View {
    LoginFormView()
      .environment(\.colorScheme, .dark)
  }
}
