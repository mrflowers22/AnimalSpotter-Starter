//
//  LoginViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var apiController: APIController?
    
    var loginType = LoginType.signUp
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // customize button appearance
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
        
    }
    
    // MARK: - Action Handlers
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        guard let ac = apiController else { return }
        
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            
            //now we have a user so check login type
            if loginType == .signUp {
                ac.signUp(with: user) { (error) in
                    if let error = error {
                        print("Error calling the signUp function: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Sign up successful", message: "Now please log in.", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: {
                                //we are going to make it easy for them to sign in
                                self.loginType = .signIn
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1 //1 s the second which means its sign in is selected
                                self.signInButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                //we must be in sign in mode
                ac.signIn(with: user) { (error) in
                    if let error = error {
                        print("Error occured during sign in function call: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            //ui changes so we need to do this on the mainqueue
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between modes
        if sender.selectedSegmentIndex == 0 {
            //they want to be in sign in mode
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
