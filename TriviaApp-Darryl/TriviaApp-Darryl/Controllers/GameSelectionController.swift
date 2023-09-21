//
//  GameSelectionController.swift
//  TriviaApp-Darryl
//
//  Created by Darryl on 2023-04-10.
//

import UIKit

class GameSelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource, QuestionManagerDelegate{
    
    func questionRequestReturned(questionModel: QuestionModel) {
        DispatchQueue.main.async {
            let gameController = GameController()
            gameController.questionModel = questionModel
            gameController.modalPresentationStyle = .fullScreen
            self.present(gameController, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Properties
    
    let categories = ["General", "Sports", "Geography", "Celebrities"]
    let difficulties = ["Easy", "Medium", "Hard"]
    
    lazy var roundContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "ic_rounds"), roundTextField)
    }()
    
    lazy var roundTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        return tf.textField(withPlaceolder: "Number Of Rounds", isSecureTextEntry: false)
    }()
    
    let categoryLabel: UILabel = {
            let label = UILabel()
            label.text = "Category"
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    let difficultyLabel: UILabel = {
        let label = UILabel()
        label.text = "Difficulty"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let difficultyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: - init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        difficultyTableView.delegate = self
        difficultyTableView.dataSource = self
    }
    
    //MARK: - Selectors
    
    @objc func handleStart() {
        guard let numberOfRoundsText = roundTextField.text,
              let numberOfRounds = Int(numberOfRoundsText),
              let selectedCategoryIndexPath = categoryTableView.indexPathForSelectedRow,
              let selectedDifficultyIndexPath = difficultyTableView.indexPathForSelectedRow else {
            print("Invalid input")
            return
        }
        
        let category = categories[selectedCategoryIndexPath.row]
        let difficulty = difficulties[selectedDifficultyIndexPath.row]
        let questionAPI = QuestionAPI()
        questionAPI.delegate = self
        questionAPI.getQuestions(numberOfRounds: numberOfRounds, category: category, difficulty: difficulty)?.resume()
    }
    
    //MARK: - Helper Functions
    
    func configureViewComponents() {
           view.backgroundColor = UIColor.mainBlue()
           roundTextField.becomeFirstResponder()
           view.addSubview(roundContainerView)
           roundContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
           
           view.addSubview(categoryLabel)
        categoryLabel.anchor(top: roundContainerView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
           
           view.addSubview(categoryTableView)
           categoryTableView.anchor(top: categoryLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 150, height: 200)
           
           view.addSubview(difficultyLabel)
        difficultyLabel.anchor(top: roundContainerView.bottomAnchor, left: categoryTableView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
           
           view.addSubview(difficultyTableView)
           difficultyTableView.anchor(top: difficultyLabel.bottomAnchor, left: categoryTableView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 150, height: 200)
        
        view.addSubview(startButton)
        startButton.anchor(top: difficultyTableView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
    }
   
    // MARK: - UITableViewDelegate UITableViewDataSource
        
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if tableView == categoryTableView {
               return categories.count
           } else {
               return difficulties.count
           }
       }
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
           if tableView == categoryTableView {
               cell.textLabel?.text = categories[indexPath.row]
           } else {
               cell.textLabel?.text = difficulties[indexPath.row]
           }
           return cell
       }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.deselectRow(at: indexPath, animated: true)
    }

}

