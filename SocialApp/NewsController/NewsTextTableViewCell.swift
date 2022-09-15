//
//  News4TableViewCell.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 31.05.2022.
//

import UIKit

class NewsTextTableViewCell: UITableViewCell {
    
    static var identifier = "NewsTextTableViewCell"
    
    private var textDiscription: UILabel = {
        let textDiscription = UILabel()
        textDiscription.translatesAutoresizingMaskIntoConstraints = false
        textDiscription.numberOfLines = 0
        return textDiscription
    }()
    
    private var buttonMore: UIButton = {
        let buttonMore = UIButton()
        buttonMore.translatesAutoresizingMaskIntoConstraints = false
        return buttonMore
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(textDiscription)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    func configure(text: String?) {
        textDiscription.text = text
        textDiscription.lineBreakMode = .byTruncatingTail

        setConstraints()
        
        
        if textDiscription.quantityOfLines >= 4 {
            textDiscription.numberOfLines = 4
            buttonMore.contentHorizontalAlignment = .left
            buttonMore.setTitle("Показать больше", for: .normal)
            buttonMore.setTitleColor(.blue, for: .normal)
            buttonMore.tag = 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RedrawCell"), object: nil)
            buttonMore.addTarget(self, action: #selector(updateLines), for: .touchUpInside)
            setButtonConstraints()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}


extension NewsTextTableViewCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            textDiscription.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textDiscription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            textDiscription.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            textDiscription.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),

        ])
    }
    

    private func setButtonConstraints() {
        
        contentView.addSubview(buttonMore)
        
        let constraints = [
            buttonMore.topAnchor.constraint(equalTo: textDiscription.bottomAnchor, constant: 8),
            buttonMore.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            buttonMore.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            buttonMore.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    

    
    
    @objc func updateLines() {
        if buttonMore.tag == 1 {
            buttonMore.setTitle("Показать меньше", for: .normal)
            textDiscription.numberOfLines = 0
            buttonMore.tag = 2
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenCell"), object: nil)
            print("Смотреть таг")
            print(buttonMore.tag)
        } else {
            buttonMore.setTitle("Показать больше", for: .normal)
            textDiscription.numberOfLines = 4
            buttonMore.tag = 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseCell"), object: nil)
            print("Смотреть таг")
            print(buttonMore.tag)
        }
    }
    
}




extension UILabel {
    
    var quantityOfLines: Int {
        let size = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        
        let text = (self.text ?? "") as NSString
        
        let height = text.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height
        
        let font = UIFont.mainCellFont
        
        let lineHeight = font.lineHeight
        
        return Int(ceil(height/lineHeight))
    }
    
}
