//
//  SwipingVC.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 03.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//

import UIKit

final class SwipingVC: UIViewController {
    let shared = NetworkService()
    private let database = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let getCoordinate = GetCityCoordinate()
    private var nameCityesArray = [CityArrayItem]()
    private var arrayData = [WeatherCity]()
    private var emptyCity = WeatherCity()

    //MARK: Properties Collection view

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    //MARK: Properties bottom panel

    private let mapsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "map.fill"), for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        button.tintColor = UIColor(named: "colorFront")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToMaps), for: .touchUpInside)
        return button
    }()

    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.rectangle.fill.on.rectangle.fill"), for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        button.tintColor = UIColor(named: "colorFront")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveToSearch), for: .touchUpInside)
        return button
    }()

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = UIColor(named: "colorFront")
        pc.pageIndicatorTintColor = .tertiaryLabel
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "colorBack")
        configureCollection()
        initialize()
        getAllItems()
        checkArray()
        movingCityName()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    //MARK: - Collection configuration

    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SwipingCell.self, forCellWithReuseIdentifier: "SwipingCell")
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
    }

    //MARK: - Fetching data from CoreData

    private func getAllItems() {
        do {
            self.nameCityesArray = try database.fetch(CityArrayItem.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }

    //MARK: - Fetching data weather

    private func checkArray() {
        if arrayData.isEmpty {
            arrayData = Array(repeating: emptyCity, count: nameCityesArray.count)
        }
    }

    private func movingCityName() {

        let cities = nameCityesArray.map { "\($0.nameCity ?? "")" }

        getCoordinate.movingCootdinateToReques(cityesArray: cities) { [weak self] index, weather in
            self?.arrayData[index] = weather
            self?.arrayData[index].nameCity = cities[index]

            DispatchQueue.main.async {
                self?.pageControl.numberOfPages = self?.arrayData.count ?? 0
                self?.collectionView.reloadData()
            }
        }
    }
}

//MARK: Methods CollectionView delegate

extension SwipingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrayData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipingCell", for: indexPath) as? SwipingCell {
            
            cell.getDataWeather(model: arrayData[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = targetContentOffset.pointee.x
        pageControl.currentPage = Int(point / view.frame.width)
    }
}

//MARK: - Setting layouts

private extension SwipingVC {

    func initialize() {
        addingSubView()
        setupLayouts()
    }

    func addingSubView() {
        view.addSubview(collectionView)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(mapsButton)
        buttonStackView.addArrangedSubview(pageControl)
        buttonStackView.addArrangedSubview(searchButton)
    }

    func setupLayouts() {
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            
            mapsButton.heightAnchor.constraint(equalToConstant: 35),
            mapsButton.widthAnchor.constraint(equalToConstant: 35),
            mapsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mapsButton.topAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: 10),
            
            searchButton.heightAnchor.constraint(equalToConstant: 35),
            searchButton.widthAnchor.constraint(equalToConstant: 35),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

//MARK: - Action

private extension SwipingVC {

    @objc func moveToSearch() {
        
        let cityList = CityListVC()
        
        let listVC = UINavigationController(rootViewController: cityList)
        
        listVC.modalPresentationStyle = .fullScreen
        present(listVC, animated: true, completion: nil)
    }

    @objc func moveToMaps() {
        print("move to MAP")
    }
}
