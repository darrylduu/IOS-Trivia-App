//
//  QuestionAPI.swift
//  TriviaApp-Darryl
//
//  Created by Darryl on 2023-04-06.
//

import UIKit

// Protocol for the Question Manager delegate
protocol QuestionManagerDelegate {
    func questionRequestReturned(questionModel: QuestionModel)
}

class QuestionAPI {
    var delegate: QuestionManagerDelegate?
    
    // Get the category number based on the category string (numbers from opentribvia)
    func getCategory(category: String) -> Int? {
        let categories = ["General": 9, "Sports": 21, "Geography": 22, "Celebrities": 26]
        return categories[category]
    }
    
    //Get questionw from the API with the specified number of rounds, category and difficulty
    //@discardableResult
    func getQuestions(numberOfRounds: Int, category: String, difficulty: String) -> URLSessionDataTask? {
        guard let categoryNumber = getCategory(category: category) else {
            print("Category not found")
            return nil
            
        }
        let urlString = "\(apiURL)amount=\(numberOfRounds)&category=\(categoryNumber)&difficulty=\(difficulty.lowercased())"
        return apiRequest(urlString: urlString)
    }

    // base API URL
    let apiURL: String = "https://opentdb.com/api.php?type=multiple&encode=base64&"

    // Send the API request
    func apiRequest(urlString: String) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [self] (data, _, error) in
            guard error == nil, let safeData = data, let questionModel = self.parseJSON(questionData: safeData) else { return }
            self.delegate?.questionRequestReturned(questionModel: questionModel)
        }
        task.resume()
        return task
    }

    // Parse the json response
    func parseJSON(questionData: Data) -> QuestionModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(QuestionData.self, from: questionData)
            var questions: [Question] = []
            for result in decodedData.results {
                var data = Data(base64Encoded: result.question)
                let question = String(data: data!, encoding: .utf8)
                data = Data(base64Encoded: result.correct_answer)
                let correctAnswer = String(data: data!, encoding: .utf8)
                var incorrectAnswers = result.incorrect_answers
                for i in 0..<incorrectAnswers.count {
                    data = Data(base64Encoded: incorrectAnswers[i])
                    incorrectAnswers[i] = String(data: data!, encoding: .utf8)!
                }
                let questionItem = Question(question: question!, correctAnswer: correctAnswer!, incorrectAnswers: incorrectAnswers)
                questions.append(questionItem)
            }
            return QuestionModel(questions: questions)
        }
        catch {
            return nil
        }
    }
}
