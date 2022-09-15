//
//  FriendsInfoCollectionViewCell.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 20.10.2020.
//

import UIKit

class FriendsInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: PhotoView!
    
    @IBOutlet weak var likeStatus: LikeStatus!
    
    @IBOutlet weak var infoName: UILabel!
    
    @IBOutlet weak var infoAge: UILabel!
    
    @IBOutlet weak var infoNativeCity: UILabel!
    
    
    func configure(viewModel: FriendViewModel) {
        self.photoView.photoImage.image = viewModel.photo
        self.infoName.text = viewModel.name
        self.infoAge.text = viewModel.age
        self.infoNativeCity.text = viewModel.city
    }
    
}
