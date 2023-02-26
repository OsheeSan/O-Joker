//
//  RegisterViewController.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase

class RegisterViewController: UIViewController {

   
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func registerTap(_ sender: UIButton) {
        guard let password = passwordTextField.text, let repeatedPassword = repeatPasswordTextField.text,
              let username = usernameTextField.text, let email = emailTextField.text,
              !password.isEmpty, password == repeatedPassword, !email.isEmpty, !username.isEmpty else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                print("Error creating user")
                return
            }
            guard let uid = authResult?.user.uid else {
                           return
                       }
            let user = ["username": username, "email" : email]
            self.ref.child("users").child(uid).setValue(user)
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                    return
                }
                
                // User signed in successfully
                print("User signed in with UID: \(result!.user.uid)")
            }
        performSegue(withIdentifier: "register", sender: registerButton)
    }
    
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardRecognizer()
        self.ref = Database.database().reference()
    }
    
    func hideKeyboardRecognizer(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.endEditing)))
    }
    


}
