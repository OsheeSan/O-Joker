//
//  JokesTableView.swift
//  O-Joker
//
//  Created by admin on 26.02.2023.
//

import UIKit

class JokesTableView: UITableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(cgColor: CGColor(red: 22/255, green: 23/255, blue: 30/255, alpha: 1))
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red: 255/255, green: 196/255, blue: 18/255, alpha: 1).cgColor
    }

}
