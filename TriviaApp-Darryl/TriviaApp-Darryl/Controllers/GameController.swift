//
//  GameController.swift
//  TriviaApp-Darryl
//
//  Created by Darryl on 2023-04-10.
//

import UIKit

class GameController: UIViewController, QuestionManagerDelegate{
    
    var questionModel: QuestionModel?
    var currentQuestionIndex = 0
    
    // MARK: - Properties
        
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Question"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answerButton1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Answer 1", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleAnswer), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let answerButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Answer 2", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleAnswer), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let answerButton3: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Answer 3", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleAnswer), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let answerButton4: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Answer 4", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleAnswer), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayQuestion()
        configureViewComponents()
    }
    
    // MARK: - Selectors
        
//    @objc func handleAnswer(_ sender: UIButton) {
//        // Handle answer selection
//        questionModel?.checkAnswer(sender)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            sender.backgroundColor = .white
//            self.currentQuestionIndex += 1
//            self.displayQuestion()
//        }
//    }
    
    @objc func handleAnswer(_ sender: UIButton) {
        // Handle answer selection
        let userAnswer = sender.title(for: .normal) ?? ""
        let correctAnswer = questionModel?.questions[currentQuestionIndex].correctAnswer

        // Reset button background color to white before changing it
        sender.backgroundColor = .white

        if userAnswer == correctAnswer {
            sender.backgroundColor = .green
        } else {
            sender.backgroundColor = .red
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.backgroundColor = .white
            self.currentQuestionIndex += 1
            self.displayQuestion()
        }
    }
    
    //MARK: - Helper Functions
    
    func configureViewComponents() {
        view.backgroundColor = UIColor.mainBlue()
        
        view.addSubview(questionLabel)
        questionLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        questionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        view.addSubview(answerButton1)
        answerButton1.anchor(top: questionLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(answerButton2)
        answerButton2.anchor(top: answerButton1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(answerButton3)
        answerButton3.anchor(top: answerButton2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(answerButton4)
        answerButton4.anchor(top: answerButton3.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
    }
    
    func displayQuestion() {
        guard let questionModel = questionModel else { return }
        if currentQuestionIndex < questionModel.getLength() {
            let question = questionModel.questions[self.currentQuestionIndex]
            questionLabel.text = question.question
            let answers = [question.correctAnswer] + question.incorrectAnswers
            let shuffledAnswers = answers.shuffled()
            answerButton1.setTitle(shuffledAnswers[0], for: .normal)
            answerButton2.setTitle(shuffledAnswers[1], for: .normal)
            answerButton3.setTitle(shuffledAnswers[2], for: .normal)
            answerButton4.setTitle(shuffledAnswers[3], for: .normal)
            
            // Reset button background colors
            answerButton1.backgroundColor = .white
            answerButton2.backgroundColor = .white
            answerButton3.backgroundColor = .white
            answerButton4.backgroundColor = .white
        } else {
            let homeController = HomeController()
            homeController.modalPresentationStyle = .fullScreen
            present(homeController, animated: true, completion: nil)
        }
    }
    
    func questionRequestReturned(questionModel: QuestionModel) {
        self.questionModel = questionModel
        DispatchQueue.main.async { [weak self] in
            self?.displayQuestion()
        }
    }
    
}
