//
//  BigButton.swift
//  O-Joker
//
//  Created by admin on 11.03.2023.
//

import UIKit

class BigButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
   
    func setupButton() {
        self.titleLabel?.font = UIFont(name: "Awenir", size: 30)
        self.setTitleColor(UIColor(red: 255/255, green: 196/255, blue: 18/255, alpha: 1), for: .normal)
        self.clipsToBounds = true
        if self.frame.height <= 40 {
            self.layer.cornerRadius = 15
        } else {
            self.layer.cornerRadius = 20
        }
        self.backgroundColor = UIColor(cgColor: CGColor(red: 30/255, green: 32/255, blue: 41/255, alpha: 1))
        self.titleLabel?.font =  UIFont(name: "Avenir", size: 20)
    }
    

}
