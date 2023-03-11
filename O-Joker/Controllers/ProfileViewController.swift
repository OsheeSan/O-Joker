//
//  ProfileViewController.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBAction func quit(_ sender: UIButton) {
        do { try Auth.auth().signOut()
        } catch {
            print("Error sign out")
        }
        print("tap")
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var Jokes: [Joke] = []
    
    var userName = ""
    var likesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserJokes()
        loadUser()
        view.backgroundColor = UIColor(cgColor: CGColor(red: 25/255, green: 26/255, blue: 30/255, alpha: 1))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func loadUser(){
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        var ref = Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").child("profileImageURL")
        _ = ref.observe(.value, with: {snapshot in
            print("1")
            if let value = snapshot.value as? String {
                print("2")
                print(value)
                if let url = URL(string: value){
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        DispatchQueue.main.async {
                            guard let imageData = data else { return }
                            self.profileImage.image = UIImage(data: imageData)
                            self.tableView.reloadData()
                        }
                    }.resume()
                }
            }
        })
    }
    
    func loadUserJokes(){
        let jokesRef = Database.database().reference().child("jokes")
        jokesRef.observeSingleEvent(of: .value, with: { snapshot  in
            self.Jokes = []
            self.likesCount = 0
            for child in snapshot.children {
                let jokeSnapshot = child as! DataSnapshot
                guard jokeSnapshot.hasChild("text"), jokeSnapshot.hasChild("author_uid"),jokeSnapshot.hasChild("likes") else {
                    print("Joke info get errorl")
                    return
                }
                guard let text = jokeSnapshot.childSnapshot(forPath: "text").value,
                      let author_uid = jokeSnapshot.childSnapshot(forPath: "author_uid").value,
                      let likes = jokeSnapshot.childSnapshot(forPath: "likes").value,
                      let author = jokeSnapshot.childSnapshot(forPath: "author").value else {
                    print("Joke info get error")
                    return
                }
                let joke = Joke(id: jokeSnapshot.key, text: text as! String, authorUID: author_uid as! String, likes:likes as! [String: Bool], author: author as! String)
                if author_uid as! String == Auth.auth().currentUser!.uid {
                    self.Jokes.append(joke)
                    self.likesCount += (likes as! [String: Bool]).count-1
                    print("Joke added")
                }
            }
            self.tableView.reloadData()
            self.likesLabel.text = String("Likes : \(self.likesCount)")
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
                let usersRef = Database.database().reference().child("users")
                let currentUserRef = usersRef.child(currentUserId)
                currentUserRef.observeSingleEvent(of: .value) { (snapshot) in
                    if let userData = snapshot.value as? [String: Any],
                       let username = userData["username"] as? String {
                        self.usernameLabel.text = username
                    }
                }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Jokes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joke") as! JokeTableViewCell
        let joke = Jokes[Jokes.count-1 - indexPath.section]
        let username = cell.viewWithTag(1) as! UILabel
        let text = cell.viewWithTag(2) as! UITextView
        let likesCount = cell.viewWithTag(3) as! UILabel
        let likeButton = cell.viewWithTag(4) as! UIButton
        let profileImageView = cell.viewWithTag(5) as! UIImageView
        profileImageView.clipsToBounds=true
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.image = profileImage.image
//        if let currentUserID = Auth.auth().currentUser?.uid {
//                let likesRef = Database.database().reference(withPath: "jokes/\(joke.id)/likes/\(currentUserID)")
//                likesRef.observeSingleEvent(of: .value, with: { snapshot in
//                    if snapshot.exists() {
//                        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//                    } else {
//                        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//                    }
//                })
//            } else {
//                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//            }
        
        likeButton.addTarget(self, action: #selector(likeTap(_:)), for: .touchUpInside)
        username.text = joke.author
        text.text = joke.text
        likesCount.text = "\(joke.likes.count-1)"
        let likesRef = Database.database().reference(withPath: "jokes/\(joke.id)/likes")
        likesRef.observeSingleEvent(of: .value, with: { snapshot in
            let likes = snapshot.value as! [String:Bool]
            likesCount.text = "\(likes.count-1)"
            joke.likes = likes
            if let _ = joke.likes[Auth.auth().currentUser!.uid] {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        })
        return cell
    }
    
    @objc func likeTap(_ sender: UIButton) {
        guard let indexPath = self.tableView.indexPath(for: sender.superview!.superview! as! JokeTableViewCell) else { return }
        let joke = Jokes[Jokes.count-1 - indexPath.section]
        DataService().like(joke: joke, button: sender, tableView: self.tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
//
//        // Add some space between each header view
//        let spacingView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10))
//        spacingView.backgroundColor = .clear
//        headerView.addSubview(spacingView)
        
        return headerView
    }
}
