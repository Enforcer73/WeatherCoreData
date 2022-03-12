//
//  SwipingCell.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 03.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//

import UIKit
import Kingfisher

final class SwipingCell: UICollectionViewCell {

    //MARK: - Top block properties

    private let cityLabel: CustomLabel = {
        let label = CustomLabel()
        label.configure(with: "City",
                        font: .boldSystemFont(ofSize: 30),
                        textAlignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleToFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let conditionLabel: CustomLabel = {
        let label = CustomLabel()
        label.configure(with: "condition",
                        font: .boldSystemFont(ofSize: 20),
                        textAlignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: CustomLabel = {
        let label = CustomLabel()
        label.configure(with: "0°C",
                        font: .boldSystemFont(ofSize: 45),
                        textAlignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tempMinLabel: CustomLabel = {
        let label = CustomLabel()
        label.configure(with: "Min: 0°C",
                        font: .boldSystemFont(ofSize: 18),
                        textAlignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tempMaxLabel: CustomLabel = {
        let label = CustomLabel()
        label.configure(with: "Max: 20°C",
                        font: .boldSystemFont(ofSize: 18),
                        textAlignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let humidityLabel: CustomLabel = {
        let lable = CustomLabel()
        lable.configure(with: "80%",
                        font: .boldSystemFont(ofSize: 18),
                        textAlignment: .center)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    private lazy var tempMinMaxStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "colorBack")
        selectedBackgroundView = .none
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Weather Current

    func getDataWeather(model: WeatherCity?) {
        guard let model = model else { return }

        let url = URL(string: "https://openweathermap.org/img/wn/\(model.icon).png")
        
        DispatchQueue.main.async { [weak self] in
            self?.iconImage.kf.setImage(with: url)
        }

        cityLabel.text = model.nameCity
        conditionLabel.text = model.description
        tempLabel.text = "\(model.tempStr)°C" //tempStr
        tempMinLabel.text = "Min: \(model.tempMinStr)°C"
        tempMaxLabel.text = "Max: \(model.tempMaxStr)°C"
        humidityLabel.text = "\(model.humidity)%"
    }
}

//MARK: - Setting layouts

private extension SwipingCell {
    
    func initialize() {
        addingSubView()
        setupLayouts()
    }

    func addingSubView() {
        contentView.addSubview(cityLabel)
        contentView.addSubview(iconImage)
        contentView.addSubview(conditionLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(tempMinMaxStack)
        
        tempMinMaxStack.addArrangedSubview(tempMinLabel)
        tempMinMaxStack.addArrangedSubview(humidityLabel)
        tempMinMaxStack.addArrangedSubview(tempMaxLabel)
    }

    func setupLayouts() {
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 50),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            iconImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImage.heightAnchor.constraint(equalToConstant: 250),
            iconImage.widthAnchor.constraint(equalToConstant: 250),
            iconImage.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),

            conditionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor),

            tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 15),
            
            tempMinMaxStack.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 15),
            tempMinMaxStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tempMinMaxStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}


