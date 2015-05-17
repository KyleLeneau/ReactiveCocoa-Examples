//
//  ViewControllerSignalProducer1.swift
//  Examples
//
//  Created by Kyle LeNeau on 5/16/15.
//  Copyright (c) 2015 Kyle LeNeau. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewControllerSignalProducer1: UIViewController {
    let userName = MutableProperty<String?>(nil)
    let password = MutableProperty<String?>(nil)
    
    lazy var loginEnabled: PropertyOf<Bool> = {
        let property = MutableProperty(false)
        
        property <~ combineLatest(self.userName.producer, self.password.producer)
            |> map { userName, password in
                if let userName = userName,
                    password = password {
                    return true
                } else {
                    return false
                }
            }
        
        return PropertyOf(property)
    }()
    
    lazy var doneAction: Action<AnyObject?, Void, NoError> = {
        return Action(enabledIf: self.loginEnabled, { _ in
            return self.login()
        })
    }()

    private func login() -> SignalProducer<Void, NoError> {
        return SignalProducer { sink, disposable in
            // Do network logic here and then sendNext, sendCompleted or sendError
            // sendNext(sink, user)
            // sendError(NSError())
            sendCompleted(sink)
        }
    }
}
