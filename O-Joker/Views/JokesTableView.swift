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
        self.backgroundColor = .brown
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
    }

}
