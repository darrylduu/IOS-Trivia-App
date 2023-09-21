//
//  SignupController.swift
//  TriviaApp-Darryl
//
//  Created by Darryl on 2023-04-02.
//

import UIKit
import Firebase

class SignupController: UIViewController, AuthDelegate {
    
    weak var delegate: AuthDelegate?
    
    //MARK: - Properties
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "default")
        return iv
    }()
    
    lazy var emailContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "ic_mail_outline_white_2x"), emailTextField)
    }()
    
    lazy var usernameContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "ic_person_outline_white_2x"), usernameTextField)
    }()
    
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "ic_lock_outline_white_2x"), passwordTextField)
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry: false)
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Username", isSecureTextEntry: false)
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Password", isSecureTextEntry: true)
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()

    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureViewComponent()
    }
    
    //MARK: - Selectors
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        
        createUser(withEmail: email, password: password, username: username)
    }
    
    @objc func handleShowLogin() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Authentication
    
    func didAuthenticateUser() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didFailAuthenticationWithError(_ error: Error) {
        print("Failed to sign up user with error: \(error.localizedDescription)")
    }

    //MARK: - Firebase
    
    func createUser(withEmail email: String, password: String, username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error{
                self.delegate?.didFailAuthenticationWithError(error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email, "username": username]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { error, ref in
                if let error = error{
                    print("Failed to update database values with error: ", error.localizedDescription)
                    return  
                }
                
                self.delegate?.didAuthenticateUser()
            }
            
        }
        
    }
    
    
    //MARK: - Helper functions
    
    func configureViewComponent() {
        view.backgroundColor = UIColor.mainBlue()
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(usernameContainerView)
        usernameContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)

        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: usernameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(signupButton)
        signupButton.anchor(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
    }


}
