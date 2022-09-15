//
//  PhotoView.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 24.10.2020.
//

import UIKit

@IBDesignable class PhotoView: UIView {
    
    
    @IBInspectable var shadowSize: CGFloat = 8 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.6 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    var photoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))

    override func draw(_ rect: CGRect) {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        view.layer.backgroundColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 70
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowSize
        view.layer.shadowOffset = .zero
        self.addSubview(view)
        
        
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = 70
        photoImage.contentMode = .scaleAspectFill
        self.addSubview(photoImage)
        
        
    }
    
    
    
    
}
