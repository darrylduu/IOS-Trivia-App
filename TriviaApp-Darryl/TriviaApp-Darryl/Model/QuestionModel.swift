// QuestionModel.swift

import UIKit

struct QuestionModel {
    var questions: [Question] //array for questions
    var currentQuestion = 0 //The index of the current question on display

    // returns the total number of questions in the model
    func getLength() -> Int {
        return questions.count
    }

    //Checks if the provided answer is correct for the current question update colour of button depending on if right or wrong
    mutating func checkAnswer(_ sender: UIButton) {
        let answer = sender.currentTitle // Get the answer text from the tapped button.
        let solution = questions[currentQuestion].correctAnswer // Get the correct answer for the current question.

        sender.backgroundColor = answer == solution ? UIColor.green : UIColor.red // Change the button color to green if the answer is correct, or red if it is bad
    }

    // Increments the current question index back to 0 if it reaches the end of the questions array
    mutating func increment() {
        currentQuestion = (currentQuestion + 1) % questions.count
    }
}

struct Question {
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}
