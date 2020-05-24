//
//  MeetupCombineAppliedTests.swift
//  MeetupCombineAppliedTests
//
//  Created by David Andres Cespedes on 5/11/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import XCTest
@testable import MeetupCombineApplied
import ComposableArchitecture

class MeetupCombineAppliedTests: XCTestCase {
    
    let testScheduler = DispatchQueue.testScheduler

    func testEmail() {
        let store = TestStore(
            initialState: LoginState(),
            reducer: loginReducer,
            environment: LoginEnvironment(
                mainQueue: testScheduler.eraseToAnyScheduler()
            )
        )
        
        store.assert(
            .send(.emailTextChanged("a@")) {
                $0.email = "a@"
            },
            .do { self.testScheduler.advance(by: 0.5) },
            .receive(.isValidEmail(false)) {
                $0.hasValidEmail = false
                $0.emailMessage = "Your should enter a valid email"
            },
            
            .send(.emailTextChanged("a@a.com")) {
                $0.email = "a@a.com"
            },
            .do { self.testScheduler.advance(by: 0.5) },
            .receive(.isValidEmail(true)) {
                $0.hasValidEmail = true
                $0.emailMessage = ""
            }
        )
    }
    
    func testPassword() {
        let store = TestStore(
            initialState: LoginState(),
            reducer: loginReducer,
            environment: LoginEnvironment(
                mainQueue: testScheduler.eraseToAnyScheduler()
            )
        )
        let allMessages =  [
            "Validate your password contains between 6 and 24 characters",
            "Your password is not strong enought",
            "Validate your passwords are equal",
        ]
        
        store.assert(
            .send(.passwordChanged("ABC$%")) {
                $0.password = "ABC$%"
            },
            .do { self.testScheduler.advance(by: 0.5) },
            .receive(.isValidPassword(allMessages)) {
                $0.hasValidPassword = false
                $0.passwordMessage = "Validate your password contains between 6 and 24 characters"
            },
            
            .send(.passwordChanged("ABC$%^123")) {
                $0.password = "ABC$%^123"
            },
            .do { self.testScheduler.advance(by: 0.5) },
            .receive(.isValidPassword(allMessages.suffix(2))) {
                 $0.passwordMessage = "Your password is not strong enought"
            },
            
            .send(.passwordChanged("ABC$%^123!@#")) {
                $0.password = "ABC$%^123!@#"
            },
            .send(.passwordAgainChanged("ABC$%^123!@")) {
                $0.passwordAgain = "ABC$%^123!@"
            },
            .do { self.testScheduler.advance(by: 0.5) },
            .receive(.isValidPassword(allMessages.suffix(1))) {
                $0.passwordMessage = "Validate your passwords are equal"
            },
            
            .send(.passwordAgainChanged("ABC$%^123!@#")) {
                $0.passwordAgain = "ABC$%^123!@#"
            },
            .do { self.testScheduler.advance(by: 0.5) },
            .receive(.isValidPassword([])) {
                $0.hasValidPassword = true
                $0.passwordMessage = ""
            }
        )
    }

}
