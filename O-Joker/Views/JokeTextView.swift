//
//  JokeTextView.swift
//  O-Joker
//
//  Created by admin on 12.03.2023.
//

import UIKit

class JokeTextView: UITextView {

    override func awakeFromNib() {
        self.backgroundColor = UIColor(cgColor: CGColor(red: 30/255, green: 32/255, blue: 41/255, alpha: 1))
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}
