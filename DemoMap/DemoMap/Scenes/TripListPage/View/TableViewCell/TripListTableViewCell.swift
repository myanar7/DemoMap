//
//  TripListViewCell.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 17.09.2023.
//

import UIKit

final class TripListTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let bookButton = UIButton()
    
    private let buttonText = "Book"
    
    var titleText: String?
    var timeText: String?
    var buttonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    override func prepareForReuse() {
        titleLabel.text = titleText
        timeLabel.text = timeText
    }
    
    private func setupCell() {
        
        selectionStyle = .none
        accessoryType = .none
        
        contentView.backgroundColor = UIColor.white

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        bookButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(bookButton)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        timeLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)

        //Leftmost
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
        
        let buttonWidth = 84.0
        
        // Rightmost
        NSLayoutConstraint.activate([
            bookButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bookButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            bookButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            bookButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        //LeftOfBookButton
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8.0),
            timeLabel.trailingAnchor.constraint(equalTo: bookButton.leadingAnchor, constant: -8.0),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
        
        bookButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        //bookButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        bookButton.layer.cornerRadius = (contentView.frame.height - 16) / 2
        bookButton.setTitle(buttonText, for: .normal)
        bookButton.backgroundColor = .systemIndigo
        
        let cellButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(didBookButtonTapped))
        bookButton.addGestureRecognizer(cellButtonTapGesture)
    }
    
    @objc private func didBookButtonTapped() {
        buttonTapped?()
    }
}
