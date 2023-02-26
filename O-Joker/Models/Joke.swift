//
//  Joke.swift
//  O-Joker
//
//  Created by admin on 26.02.2023.
//

import Foundation
import Firebase

class Joke {
    var id: String
    var text: String
    var author_uid: String
    var likes: [String: Bool]
    var author: String
    
    init(id: String, text: String, authorUID: String, likes: [String: Bool], author: String) {
        self.id = id
        self.text = text
        self.author_uid = authorUID
        self.likes = likes
        self.author = author
    }
    
    convenience init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let text = value["text"] as? String,
              let authorUID = value["author_uid"] as? String,
              let author = value["author"] as? String,
              let likes = value["likes"] as? [String: Bool] else {
            return nil
        }
        self.init(id: snapshot.key, text: text, authorUID: authorUID, likes: likes, author: author)
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [
            "text": text,
            "author_uid": author_uid,
            "author" : author,
            "likes": likes
        ] as [String : Any]
        
        return dict
    }
}
