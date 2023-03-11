//
//  CreateJokeViewController.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import UIKit
import Firebase

class CreateJokeViewController: UIViewController {
    
    @IBOutlet var jokeTextView: UITextView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor(cgColor: CGColor(red: 25/255, green: 26/255, blue: 30/255, alpha: 1))
        }

        @IBAction func createJokeButtonPressed(_ sender: UIButton) {
            guard let jokeText = jokeTextView.text else {
                        print("Error: No text entered for new joke.")
                        return
                    }
           createJoke(jokeText: jokeText)
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
        
    func createJoke(jokeText: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not authenticated.")
            return
        }
        var author = "??/"
        let usersRef = Database.database().reference().child("users")
        let currentUserRef = usersRef.child(currentUser.uid)
                   currentUserRef.observeSingleEvent(of: .value) { (snapshot) in
                       if let userData = snapshot.value as? [String: Any],
                          let username = userData["username"] as? String {
                           author = username
                           let jokeRef = Database.database().reference().child("jokes").childByAutoId()
                           let jokeId = jokeRef.key ?? ""
                           let jokeData = [
                               "text": jokeText,
                               "author_uid": currentUser.uid,
                               "author": author,
                               "likes":["init":false]
                           ] as [String : Any]
                           jokeRef.setValue(jokeData) { error, _ in
                               if let error = error {
                                   print("Error creating joke: \(error.localizedDescription)")
                               } else {
                                   print("Joke created successfully with ID: \(jokeId)")
                               }
                           }
                       }
                   }
    }
}

