//
//  JokesViewController.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import UIKit
import Firebase

class JokesViewController: UIViewController {
    
    @IBOutlet weak var tableView: JokesTableView!
    
    var Jokes: [Joke] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJokes()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func loadJokes(){
        let jokesRef = Database.database().reference().child("jokes")
        jokesRef.observeSingleEvent(of: .value, with: { snapshot  in
            self.Jokes = []
            for child in snapshot.children {
                let jokeSnapshot = child as! DataSnapshot
                guard jokeSnapshot.hasChild("text"), jokeSnapshot.hasChild("author_uid"),jokeSnapshot.hasChild("likes") else {
                    print("Joke info get errorl")
                    return
                }
                guard let text = jokeSnapshot.childSnapshot(forPath: "text").value,
                      let author_uid = jokeSnapshot.childSnapshot(forPath: "author_uid").value,
                      let likes = jokeSnapshot.childSnapshot(forPath: "likes").value,
                      let author =  jokeSnapshot.childSnapshot(forPath: "author").value else {
                    print("Joke info get error")
                    return
                }
                let joke = Joke(id: jokeSnapshot.key, text: text as! String, authorUID: author_uid as! String, likes:likes as! [String: Bool], author: author as! String)
                self.Jokes.append(joke)
            }
            self.tableView.reloadData()
        })
    }
    
}
extension JokesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Jokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joke") as! JokeTableViewCell
        let joke = Jokes[Jokes.count-1 - indexPath.row]
        let username = cell.viewWithTag(1) as! UILabel
        let text = cell.viewWithTag(2) as! UITextView
        let likesCount = cell.viewWithTag(3) as! UILabel
        let likeButton = cell.viewWithTag(4) as! UIButton
        likeButton.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        
        
//        let userProfileImage = cell.viewWithTag(5) as! UIImageView
//        userProfileImage.clipsToBounds = true
//        userProfileImage.layer.cornerRadius = userProfileImage.frame.height/2
//        let ref = Database.database().reference().child("users").child("\(joke.author_uid)").child("profileImageURL")
//        ref.observeSingleEvent(of: .value, with: {snapshot in
//            if let value = snapshot.value as? String {
//                if let url = URL(string: value){
//                    URLSession.shared.dataTask(with: url) { (data, response, error) in
//                        DispatchQueue.main.async {
//                            guard let imageData = data else { return }
//                            userProfileImage.image = UIImage(data: imageData)
//                        }
//                    }.resume()
//                }
//            }
//        })
        username.text = joke.author
        likesCount.text = "\(joke.likes.count-1)"
        let likesRef = Database.database().reference(withPath: "jokes/\(joke.id)/likes")
        likesRef.observeSingleEvent(of: .value, with: { snapshot in
            let likes = snapshot.value as! [String:Bool]
            likesCount.text = "\(likes.count-1)"
            joke.likes = likes
            if let currentUserID = Auth.auth().currentUser?.uid {
                if let _ = joke.likes[Auth.auth().currentUser!.uid] {
                    likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
                else {
                    likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
    //            let likesRef = Database.database().reference(withPath: "jokes/\(joke.id)/likes/\(currentUserID)")
    //            likesRef.observeSingleEvent(of: .value, with: { snapshot in
    //                    if snapshot.exists() {
    //                        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    //                    } else {
    //                        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    //                    }
    //            })
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        })
        text.text = joke.text
        return cell
    }
    
    
    @objc func likeTap(_ sender: UIButton) {
        guard let indexPath = self.tableView.indexPath(for: sender.superview!.superview! as! JokeTableViewCell) else { return }
        let joke = Jokes[Jokes.count-1 - indexPath.row]
        DataService().like(joke: joke, button: sender, tableView: self.tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
