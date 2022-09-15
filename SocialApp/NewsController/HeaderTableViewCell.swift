//
//  HeaderTableViewCell.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 17.06.2022.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    static var identifier = "HeaderTableViewCell"

    private var avatar = UIImageView() {
        didSet {
            avatar.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    private var authorName = UILabel() {
        didSet {
            authorName.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    private var date = UILabel() {
        didSet {
            date.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private let insets: CGFloat = 8.0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatar.frame = CGRect(x: 8, y: 8, width: 50, height: 50)
        avatar.layer.cornerRadius = 50 / 2
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.backgroundColor = .white //Везде проставил бэкграунд
        contentView.addSubview(avatar)
        
        authorName.frame = CGRect(x: 24 + avatar.frame.width, y: 8, width: frame.width - avatar.frame.width, height: 24)
        authorName.text = ""
        authorName.font = UIFont.mainHeaderFont
        authorName.backgroundColor = .white //Везде проставил бэкграунд
        contentView.addSubview(authorName)
        
        
        date.frame = CGRect(x: 24 + avatar.frame.width, y: authorName.frame.height + 12, width: frame.width - avatar.frame.width, height: 24)
        date.text = ""
        date.font = UIFont.supplementaryHeaderFont
        date.textColor = .gray
        date.backgroundColor = .white //Везде проставил бэкграунд
        contentView.addSubview(date)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(date: String?, name: String?, photo: String) {
        
        self.date.text = date
//        self.getAuthorNameSize(text: name ?? "")
        
        
        self.authorName.text = name
        
        
        let url = URL(string: photo)
        guard url != nil else { return }
        do {
            let data = try Data(contentsOf: url!)
            self.avatar.image = UIImage(data: data)
        } catch {
            print(error)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        getAuthorNameFrame()
    }
    
}


extension HeaderTableViewCell {
    
    
    func getAuthorNameSize(text: String) -> CGSize {

        let maxWidth = bounds.width - insets
        let font = UIFont.mainHeaderFont

        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        let width = Double(rect.size.width)
        
        let height = Double(rect.size.height)
        
        let size = CGSize(width: ceil(width), height: ceil(height))
        
        return size

    }
    
    
    func getAuthorNameFrame() {
        
        let authorNameSize = getAuthorNameSize(text: authorName.text ?? "")
        
        let authorNameX = (bounds.width - authorNameSize.width) / 2
        
        let authorNameOrigin = CGPoint(x: authorNameX, y: insets)
        
        authorName.frame = CGRect(origin: authorNameOrigin, size: authorNameSize)
        
    }
    
    
    func setAuthorName(text: String) {
        authorName.text = text
        getAuthorNameFrame()
    }
    

    
}
