//
//  MyFriendsViewCell.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 15.10.2020.
//

import UIKit

class MyFriendsViewCell: UITableViewCell {
    

    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendPhoto: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
