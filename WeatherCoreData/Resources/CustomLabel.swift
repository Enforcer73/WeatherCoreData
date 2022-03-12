//
//  CustomLabel.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 02.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String, font: UIFont, textAlignment: NSTextAlignment) {
        self.text = text
        self.font = font
        self.textAlignment = textAlignment
    }
}

extension CustomLabel {
    
    func setupUI() {
        text = ""
        textColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
