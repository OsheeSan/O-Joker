//
//  DataService.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import Foundation
import Firebase
 
class DataService {
    func like(joke: Joke, button: UIButton, tableView: UITableView, indexPath: IndexPath){
           guard let currentUserID = Auth.auth().currentUser?.uid else {
               return
           }
        let likesRef = Database.database().reference(withPath: "jokes/\(joke.id)/likes")
           likesRef.observeSingleEvent(of: .value, with: { snapshot in
               if snapshot.hasChild(currentUserID) {
                   button.setImage(UIImage(systemName: "heart"), for: .normal)
                   likesRef.child(currentUserID).removeValue()
                   joke.likes.removeValue(forKey: joke.id)
               } else {
                   button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                   likesRef.child(currentUserID).setValue(true)
                   joke.likes[joke.id] = false
               }
               self.updateLikes(tableView: tableView, indexPath: indexPath, joke: joke)
           })
    }
    
    func updateLikes(tableView: UITableView, indexPath: IndexPath, joke: Joke){
        let likesRef = Database.database().reference(withPath: "jokes/\(joke.id)/likes")
        likesRef.observeSingleEvent(of: .value, with: { snapshot in
            let likes = snapshot.value as! [String:Bool]
            joke.likes = likes
            let likesLabel = tableView.cellForRow(at: indexPath)?.viewWithTag(3) as! UILabel
            likesLabel.text = "\(likes.count-1)"
        })
    }
    
    
}

