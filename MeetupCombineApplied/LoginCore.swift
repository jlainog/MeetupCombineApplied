import Foundation
import ComposableArchitecture

//MARK:- State
public struct LoginState: Equatable {
    var email = ""
    var password = ""
    var passwordAgain = ""
    
    var hasValidEmail = false
    var hasValidPassword = false
    
    var emailMessage = ""
    var passwordMessage = ""
}

//MARK:- Action
public enum LoginAction: Equatable {
    case emailTextChanged(String)
    case isValidEmail(Bool)
    
    case passwordChanged(String)
    case passwordAgainChanged(String)
    case isValidPassword([String])
}

//MARK:- Environment
public struct LoginEnvironment {
    var mainQueue = DispatchQueue.main.eraseToAnyScheduler()
}

//MARK:- Reducer
public let loginReducer = Reducer<LoginState, LoginAction, LoginEnvironment> {
    state, action, environment in
    struct PasswordValidatorID: Hashable {}
    
    switch action {
    case .emailTextChanged(let email):
        struct EmailCheckID: Hashable {}
        
        state.email = email
        return Effect<Bool, Never>
            .future { callback in
                let emailRegexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let isValid = email.range(of: emailRegexPattern, options: .regularExpression) != nil
                callback(.success(isValid))
            }
            .debounce(id: EmailCheckID(),
                      for: 0.5,
                      scheduler: environment.mainQueue)
            .map(LoginAction.isValidEmail)
            .eraseToEffect()
        
    case .isValidEmail(let isValid):
        state.hasValidEmail = isValid
        state.emailMessage = isValid
            ? ""
            : "Your should enter a valid email"
        return .none
        
    case .passwordChanged(let password):
        state.password = password
        return Effect<[String], Never>
            .future { [password = state.password, passwordAgain = state.passwordAgain] callback in
                let messages = passwordValidator(password, passwordAgain)
                callback(.success(messages))
            }
            .debounce(id: PasswordValidatorID(),
                      for: 0.5,
                      scheduler: environment.mainQueue)
            .map(LoginAction.isValidPassword)
        
    case .passwordAgainChanged(let password):
        state.passwordAgain = password
        return Effect<[String], Never>
            .future { [password = state.password, passwordAgain = state.passwordAgain] callback in
                let messages = passwordValidator(password, passwordAgain)
                callback(.success(messages))
            }
            .debounce(id: PasswordValidatorID(),
                      for: 0.5,
                      scheduler: environment.mainQueue)
            .map(LoginAction.isValidPassword)
        
    case .isValidPassword(let messages):
        state.hasValidPassword = messages.isEmpty
        state.passwordMessage = messages.first ?? ""
        return .none
    }
}

func passwordValidator(_ password: String, _ passwordAgain: String) -> [String] {
    var messages = [String]()
    
    if password.isEmpty {
        messages.append("Your password can't be empty")
    }
    
    if let message = evaluateRules(password: password) {
        messages.append(message)
    }
    
    if let message = passwordStrenght(password: password) {
        messages.append(message)
    }
    
    if password != passwordAgain {
        messages.append("Validate your passwords are equal")
    }
    
    return messages
}

func passwordStrenght(password: String) -> String? {
    let strength = Navajo.strength(ofPassword: password)

    switch strength {
    case .strong, .veryStrong:
        return nil
        
    default:
        return "Your password is not strong enought"
    }
}

func evaluateRules(password: String) -> String? {
    let lengthRule = LengthRule(min: 6, max: 24)
    let uppercaseRule = RequiredCharacterRule(preset: .uppercaseCharacter)
    
    if lengthRule.evaluate(password) {
        return "Validate your password contains between 6 and 24 characters"
    } else if uppercaseRule.evaluate(password) {
        return "Validate your password contains at least one uppercase character"
    }

    return nil
}
