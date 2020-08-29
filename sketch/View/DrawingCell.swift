//
//  DrawingCell.swift
//  sketch
//
//  Created by manavarthivenkat on 29/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
class DrawingCell : UITableViewCell{
    let leftImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(leftImageView)
        NSLayoutConstraint.activate([
            self.contentView.heightAnchor.constraint(equalToConstant: 80),
            leftImageView.heightAnchor.constraint(equalToConstant: 60),
            leftImageView.widthAnchor.constraint(equalToConstant: 60),
            leftImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            leftImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.font = UIFont.systemFont(ofSize: 20)
        self.textLabel?.frame = CGRect(x: self.textLabel!.frame.origin.x + 80, y: self.textLabel!.frame.origin.y, width: self.textLabel!.frame.width - 80, height: self.textLabel!.frame.height)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
