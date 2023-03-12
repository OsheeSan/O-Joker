//
//  ProfileLikesLabel.swift
//  O-Joker
//
//  Created by admin on 12.03.2023.
//

import UIKit

class ProfileLikesLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    func setupLabel(){
        self.textColor = UIColor(red: 255/255, green: 196/255, blue: 18/255, alpha: 1)
        self.font = UIFont(name: "Avenir", size: 20)
        let backgroundView = UIView()
        backgroundView.bounds = self.bounds
    }

}
