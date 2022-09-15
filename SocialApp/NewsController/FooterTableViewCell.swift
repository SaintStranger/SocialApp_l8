//
//  FooterTableViewCell.swift
//  SocialApp
//
//  Created by test on 17.06.2022.
//

import UIKit

class FooterTableViewCell: UITableViewCell {
    
    static var identifier = "FooterTableViewCell"
    
    let likesView = UIView()
    let likesIcon = UIImageView(image: UIImage(systemName: "heart"))
    let likesCount = UILabel()
    let commentsView = UIView()
    let commentsIcon = UIImageView(image: UIImage(systemName: "quote.bubble"))
    let commentsCount = UILabel()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        likesView.frame = CGRect(x: 8, y: 8, width: 68, height: 32)
        
        likesIcon.tintColor = .black
        likesIcon.frame = CGRect(x: 8, y: 4, width: 24, height: 24)
        likesIcon.contentMode = .scaleAspectFit
        
        likesCount.text = ""
        
        likesCount.frame = CGRect(x: likesIcon.frame.width + 12, y: 4, width: 32, height: 24)
        
        likesView.backgroundColor = UIColor(red: CGFloat(137.0/255.0), green: CGFloat(207.0/255.0), blue: CGFloat(240.0/255.0), alpha: 1)
        likesView.layer.cornerRadius = 16
        likesView.layer.masksToBounds = true
        
        likesView.addSubview(likesIcon)
        likesView.addSubview(likesCount)
        contentView.addSubview(likesView)

        
        commentsView.frame = CGRect(x: 16 + likesView.frame.width, y: 8, width: 68, height: 32)
        commentsIcon.tintColor = .black
        commentsIcon.frame = CGRect(x: 8, y: 4, width: 24, height: 24)
        commentsIcon.contentMode = .scaleAspectFit
        
        commentsCount.frame = CGRect(x: commentsIcon.frame.width + 12, y: 4, width: 32, height: 24)
        commentsCount.text = ""
        commentsView.backgroundColor = UIColor(red: CGFloat(137.0/255.0), green: CGFloat(207.0/255.0), blue: CGFloat(240.0/255.0), alpha: 1)
        commentsView.layer.cornerRadius = 16
        commentsView.layer.masksToBounds = true
        
        
        commentsView.addSubview(commentsIcon)
        commentsView.addSubview(commentsCount)
        
        contentView.addSubview(commentsView)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        
    

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(likes: Int?, comments: Int?) {
        if likes != nil {
            likesCount.text = "\(likes ?? 0)"
        }
        
        if comments != nil {
            commentsCount.text = "\(comments ?? 0)"
        }
    }
    
}
