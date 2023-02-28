//
//  DataService.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import Foundation
import Firebase
 
class DataService {
    func like(jokeId: String, button: UIButton){
           guard let currentUserID = Auth.auth().currentUser?.uid else {
               return
           }
           let likesRef = Database.database().reference(withPath: "jokes/\(jokeId)/likes")
           likesRef.observeSingleEvent(of: .value, with: { snapshot in
               if snapshot.hasChild(currentUserID) {
                   likesRef.child(currentUserID).removeValue()
                   button.setImage(UIImage(systemName: "heart"), for: .normal)
               } else {
                   likesRef.child(currentUserID).setValue(true)
                   button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
               }
           })
    }
    
    
}

