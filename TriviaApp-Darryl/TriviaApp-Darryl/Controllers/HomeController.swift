//
//  HomeController.swift
//  TriviaApp-Darryl
//
//  Created by Darryl on 2023-04-02.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "default")
        return iv
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PLAY!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let signoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "ic_back_arrow"), style: .plain, target: self, action: #selector(handleSignOut))
        button.tintColor = .white
        return button
    }()
    
    //MARK: - init

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
    }
    
    //MARK: - Selectors
    
    @objc func handleSignOut(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handlePlay() {
        let gameSelectionControoler = GameSelectionController()
        gameSelectionControoler.modalPresentationStyle = .fullScreen
        present(gameSelectionControoler, animated: true, completion: nil)
    }
    
    // MARK: - Firebase
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            navController.navigationBar.barStyle = .black
            navController.modalPresentationStyle = .fullScreen // Add this line
            self.present(navController, animated: true, completion: nil)
            
        } catch let error {
            print("Failed to signout with error...", error)
        }
    }
    
    func authenticateUserAndConfigureView() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            }
        }else {
            configureViewComponents()
        }
        
    }
    
    //MARK: - Helper Functions
    
    func configureViewComponents() {
        
        view.backgroundColor = UIColor.mainBlue()
        
        navigationItem.leftBarButtonItem = signoutButton
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue()
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(playButton)
        playButton.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
    }


}
