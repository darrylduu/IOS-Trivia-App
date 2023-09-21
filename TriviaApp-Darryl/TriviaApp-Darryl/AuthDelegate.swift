//
//  AuthDelegate.swift
//  TriviaApp-Darryl
//
//  Created by Darryl on 2023-04-05.
//

import Foundation

protocol AuthDelegate: AnyObject {
    func didAuthenticateUser()
    func didFailAuthenticationWithError(_ error: Error)
}
