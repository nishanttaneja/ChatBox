//
//  ChatInfoView.swift
//  ChatBox
//
//  Created by Nishant Taneja on 10/05/21.
//

import UIKit

class ChatInfoView: UIView {
    // Constants
    private let padding: CGFloat = 6
    
    // Views
    private let imageView: UIImageView = {
        let image = UIImage(systemName: "person.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Subtitle"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    // Properties
    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }
    
    // Constraints
    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate([
            // ImageView
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.widthAnchor.constraint(equalToConstant: frame.height - padding),
            // Title
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: padding),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 0.75*(frame.height - 2*padding)),
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: padding),
            subtitleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    // LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.height/2
    }
    
    // Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
