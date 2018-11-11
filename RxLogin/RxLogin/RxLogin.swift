//
//  RxLogin.swift
//  RxLogin
//
//  Created by Aline Borges on 09/11/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftUtilities

extension ViewController {
    
    // Username should be VALID when more than 3 characters
    func isUsernameValid(username: Observable<String>) -> Observable<Bool> {
        return username.map({$0.count > 3})
    }
    
    // Password should be VALID when more than 3 characters
    func isPasswordValid(password: Observable<String>) -> Observable<Bool> {
        return password.map({$0.count > 3})
    }
    
    // Button should NEVER be enabled when isLoading
    // Button should be enabled when username AND password are both VALID
    func isButtonEnabled(isLoading: Observable<Bool>,
                         isUsernameValid: Observable<Bool>,
                         isPasswordValid: Observable<Bool>) -> Observable<Bool> {
        
        let inputValid = Observable.combineLatest(isUsernameValid, isPasswordValid) {
            usernameValid, passwordValid in
            usernameValid && passwordValid
        }
        
        return Observable.combineLatest(inputValid, isLoading) {
            inputValid, isLoading in
            if isLoading {return false}
            if inputValid {return true}
            return false
        }
    }
    
    // Do login using `self.service.login(username: String, password: String) -> Single<Result>`
    // Result can be `.success` or `.failure`
    // Use `.trackActivity(self.isLoading)` on request to show loading in the view
    func doLogin(username: Observable<String>,
                 password: Observable<String>,
                 loginAction: Observable<Void>) -> Observable<Result> {
        
        let input  = Observable.combineLatest(username, password)
        return loginAction
            .withLatestFrom(input)
            .flatMap { username, password in
                return self.service.login(username: username, password: password)
                    .trackActivity(self.isLoading)
        
        }
    }
    
}
