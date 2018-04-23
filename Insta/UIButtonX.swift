//
//  UIButtonX.swift
//  Insta
//
//  Created by Yermakov Anton on 26.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit

@IBDesignable

class UIButtonX: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
