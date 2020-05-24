//
//  SnapshotTests.swift
//  MeetupCombineAppliedTests
//
//  Created by Jaime Andres Laino Guerra on 24/05/20.
//  Copyright © 2020 David Andres Cespedes. All rights reserved.
//

import XCTest
@testable import MeetupCombineApplied
import ComposableArchitecture
import SnapshotTesting
import SwiftUI

class SnapshotTests: XCTestCase {
    
    let testScheduler = DispatchQueue.testScheduler

    func testLoginView() {
        let store = Store(
            initialState: LoginState(),
            reducer: loginReducer,
            environment: LoginEnvironment(
                mainQueue: testScheduler.eraseToAnyScheduler()
            )
        )
        let loginView = LoginFormView(store: store)
        let viewStore = ViewStore(store)
        
        assertSnapshot(matching: loginView, as: .windowedImage)
        
        viewStore.send(.emailTextChanged("a@"))
        testScheduler.advance(by: 0.5)
        assertSnapshot(matching: loginView, as: .windowedImage)
        
        viewStore.send(.emailTextChanged("a@a.com"))
        testScheduler.advance(by: 0.5)
        assertSnapshot(matching: loginView, as: .windowedImage)
        
        viewStore.send(.passwordChanged("ABC$%"))
        testScheduler.advance(by: 0.5)
        assertSnapshot(matching: loginView, as: .windowedImage)
        
        viewStore.send(.passwordChanged("ABC$%^123"))
        testScheduler.advance(by: 0.5)
        assertSnapshot(matching: loginView, as: .windowedImage)
        
        viewStore.send(.passwordChanged("ABC$%^123!@#"))
        testScheduler.advance(by: 0.5)
        assertSnapshot(matching: loginView, as: .windowedImage)
        
        viewStore.send(.passwordAgainChanged("ABC$%^123!@#"))
        testScheduler.advance(by: 0.5)
        assertSnapshot(matching: loginView, as: .windowedImage)
    }

}

extension Snapshotting where Value: View, Format == UIImage {
    static var windowedImage: Snapshotting {
        return Snapshotting<UIImage, UIImage>.image.asyncPullback { view in
            Async<UIImage> { callback in
                UIView.setAnimationsEnabled(false)
                
                let window = UIApplication.shared.windows.first!
                let vc = UIHostingController(rootView: view)
                
                window.rootViewController = vc
                vc.view.frame = UIScreen.main.bounds
                
                DispatchQueue.main.async {
                    let image = UIGraphicsImageRenderer(bounds: window.bounds).image { ctx in
                        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                    }
                    callback(image)
                    UIView.setAnimationsEnabled(true)
                }
            }
        }
    }
}
