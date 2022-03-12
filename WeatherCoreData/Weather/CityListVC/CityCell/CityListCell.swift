//
//  CityListCell.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 02.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//

import UIKit

class CityListCell: UITableViewCell {

    //MARK: - Properties

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private let cityLabel: CustomLabel = {
        let label = CustomLabel()
        label.configure(with: "City",
                        font: .boldSystemFont(ofSize: 17),
                        textAlignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    private let tempLabel: CustomLabel = { //"0°C"
        let label = CustomLabel()
        label.configure(with: "0°C",
                        font: .boldSystemFont(ofSize: 17),
                        textAlignment: .right)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
        backgroundColor = UIColor(named: "colorBack")
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = contentView.bounds
        stackView.frame = containerView.bounds
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    //MARK: - Configure cell

    func getData(model: WeatherCity?) {
        guard let model = model else { return }
        
        let url = URL(string: "https://openweathermap.org/img/wn/\(model.icon).png")
        
        DispatchQueue.main.async { [weak self] in
            self?.iconImage.kf.setImage(with: url)
        }
        
        cityLabel.text = model.nameCity
        tempLabel.text = "\(model.tempStr)°C"
    }
}

private extension CityListCell {

    private func initialize() {
        addingSubview()
        settingLayouts()
    }

    private func addingSubview() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(iconImage)
        stackView.addArrangedSubview(tempLabel)
    }

    private func settingLayouts() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
