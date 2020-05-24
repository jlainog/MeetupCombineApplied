//
//  CombineViewController.swift
//  MeetupCombineApplied
//
//  Created by David Andres Cespedes on 5/11/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

class LoginSwiftUIViewController: UIHostingController<AnyView> {
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        let deletate = UIApplication.shared.delegate as! AppDelegate
        super.init(
            coder: aDecoder,
            rootView: AnyView(
                LoginFormView(store: deletate.store)
            )
        )
    }
}

extension LoginFormView.State {
    init(state: LoginState) {
        self.email = state.email
        self.emailMessage = state.emailMessage
        self.password = state.password
        self.passwordAgain = state.passwordAgain
        self.passwordMessage = state.passwordMessage
        self.enabledContinueButton = state.hasValidEmail && state.hasValidPassword
    }
}

struct LoginFormView: View {
    struct State: Equatable {
        var email = ""
        var password = ""
        var passwordAgain = ""
        
        var emailMessage = ""
        var passwordMessage = ""
        
        var enabledContinueButton = false
    }
    
    let store: Store<LoginState, LoginAction>
    
    var body: some View {
        WithViewStore(store.scope(state: State.init(state:))) { viewStore in
            Form {
                Section(footer: Text(viewStore.emailMessage).foregroundColor(.red)) {
                    TextField("Email",
                              text: viewStore.binding(
                                get: \.email,
                                send: LoginAction.emailTextChanged
                        )
                    ).autocapitalization(.none)
                }
                Section(footer: Text(viewStore.passwordMessage).foregroundColor(.red)) {
                    SecureField("Password",
                                text: viewStore.binding(
                                    get: \.password,
                                    send: LoginAction.passwordChanged
                        )
                    )
                    SecureField("Password again",
                                text: viewStore.binding(
                                    get: \.passwordAgain,
                                    send: LoginAction.passwordAgainChanged
                        )
                    )
                }
                Section {
                    Button(action: {},
                           label: { Text("Continue") })
                        .disabled(!viewStore.enabledContinueButton)
                }
            }
        }
    }
}

struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView(
            store: Store(
                initialState: LoginState(),
                reducer: loginReducer,
                environment: LoginEnvironment()
            )
        ).environment(\.colorScheme, .dark)
    }
}
