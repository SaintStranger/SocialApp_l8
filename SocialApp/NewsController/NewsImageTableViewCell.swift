//
//  NewsImageTableViewCell.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 31.05.2022.
//

import UIKit

class NewsImageTableViewCell: UITableViewCell {
    
    static let identifier: String = "NewsImageTableViewCell"

    private let imagePhoto: UIImageView = {
        let imagePhoto = UIImageView()
        imagePhoto.translatesAutoresizingMaskIntoConstraints = false
        return imagePhoto
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setConstraints()
        contentView.addSubview(imagePhoto)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePhoto.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(photos: [UIImage?]) {
        

        imagePhoto.image = photos[0]
        

    
    }
    
}
    
extension NewsImageTableViewCell {
    
    private func setConstraints() {

        contentView.addSubview(imagePhoto)

        let topConstraint = imagePhoto.topAnchor.constraint(equalTo: contentView.topAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            imagePhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imagePhoto.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imagePhoto.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
}
