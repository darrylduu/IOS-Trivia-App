//
//  GameControllerDelegate.swift
//  TriviaApp-Darryl
//
//  Created by Darryl on 2023-04-14.
//

import Foundation

// GameControllerDelegate protocol
protocol GameControllerDelegate: AnyObject {
    func didFinishGame(withScore score: Int)
}
