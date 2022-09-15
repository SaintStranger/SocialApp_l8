//
//  LikeStatus.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 27.10.2020.
//

import UIKit

class LikeStatus: UIControl {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.likePhoto()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.likePhoto()
    }

    
    
    var likesCount = 0 {
        didSet {
            self.likePhoto()
        }
    }
    
    var imageButton = UIImage(systemName: "heart") {
        didSet {
            self.likePhoto()
        }
    }
    
    var likeColor: UIColor = .systemBlue {
        didSet {
            self.likePhoto()
        }
    }
    
    var numberOfLikes = UILabel()
    
    var likeButton = UIButton()
    
    var statusOfLike = [UILabel(), UIButton()]
    
    var stackView = UIStackView()

    
    
    
    public func likePhoto() {

        numberOfLikes.text = "\(likesCount)"
        numberOfLikes.textColor = likeColor
        
        likeButton.setImage(imageButton, for: .normal)
        likeButton.tintColor = likeColor
        likeButton.addTarget(self, action: #selector(likeStatus(_:)), for: .touchUpInside)


        statusOfLike.append(numberOfLikes)
        statusOfLike.append(likeButton)
        
    

        stackView = UIStackView(arrangedSubviews: self.statusOfLike)

        self.addSubview(stackView)

        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing
    }
 
    
    
    @objc func likeStatus(_ sender: UIButton) {
        
        if imageButton == UIImage(systemName: "heart") {
            imageButton = UIImage(systemName: "heart.fill")
            likeColor = .systemRed
            likesCount += 1

        } else {
            imageButton = UIImage(systemName: "heart")
            likeColor = .systemBlue
            likesCount -= 1
        }
        
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.bounds = bounds
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
//        stackView.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
    }

}
