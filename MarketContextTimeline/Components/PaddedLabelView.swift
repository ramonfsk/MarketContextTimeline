//
//  PaddedLabelView.swift
//  MarketContextTimeline
//
//  Created by Ramon Ferreira on 22/10/24.
//

import UIKit

final class PaddedLabelView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        
        return label
    }()
    
    init(frame: CGRect = .zero, title: String, backgroundColor: UIColor) {
        super.init(frame: frame)
        self.titleLabel.text = title
        self.backgroundColor = backgroundColor
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaddedLabelView {
    func setupView() {
        setupLayout()
        setupHierarchy()
        setupConstraints()
    }
    
    func setupLayout() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    func setupHierarchy() {
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        let edgeConstraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0),
        ]
        
        // this prevents auto-layout complaints
        edgeConstraints[2].priority = .required - 1
        edgeConstraints[3].priority = .required - 1
        NSLayoutConstraint.activate(edgeConstraints)
    }
}
