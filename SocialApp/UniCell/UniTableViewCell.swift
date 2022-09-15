//
//  UniTableViewCell.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 27.10.2020.
//

import UIKit

class UniTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var avatarView: UIImageView!

    @IBOutlet weak var name: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
