//
//  UIViewX.swift
//  Insta
//
//  Created by Yermakov Anton on 26.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
@IBDesignable

class UIViewX: UIView {

    @IBInspectable var firstColor : UIColor = UIColor.clear{
        didSet{
            updateValue()
        }
    }
    
    @IBInspectable var secondColor : UIColor = UIColor.clear{
        didSet{
            updateValue()
        }
    }
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
       }
    }

    
    func updateValue(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
    }
    
    

}
