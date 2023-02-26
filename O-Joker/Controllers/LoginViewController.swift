//
//  ViewController.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        guard let password = passwordTextfield.text, let email = emailTextField.text,
              !password.isEmpty,!email.isEmpty  else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                    return
                }
                
                // User signed in successfully
                print("User signed in with UID: \(result!.user.uid)")
            }
        if Auth.auth().currentUser != nil {
                    performSegue(withIdentifier: "login", sender: self)
                }
    }
    
    var ref = DatabaseReference.init()
    
    var userNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        hideKeyboardRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "login", sender: UIButton())
            print("User loggggiiiiin")
        } else {
            print("no user")
        }
    }
    
    func hideKeyboardRecognizer(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing)))
    }

}

