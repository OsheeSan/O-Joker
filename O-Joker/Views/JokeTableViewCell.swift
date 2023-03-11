//
//  JokeTableViewCell.swift
//  O-Joker
//
//  Created by admin on 23.02.2023.
//

import UIKit

class JokeTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        setupCell()
    }
    
    func setupCell(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor(cgColor: CGColor(red: 25/255, green: 26/255, blue: 30/255, alpha: 1))
//        let verticalPadding: CGFloat = 8
//        let maskLayer = CALayer()
//        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
//        layer.mask = maskLayer
    }
    
}
