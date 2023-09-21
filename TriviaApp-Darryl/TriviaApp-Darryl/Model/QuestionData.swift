//
//  QuestionData.swift
//  TriviaApp-Darryl
//
//  Created by Darryl on 2023-04-06.
//

import Foundation

struct QuestionData: Decodable {
    let response_code: Int
    let results: [Result]
}

struct Result: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    var incorrect_answers: [String]
}
