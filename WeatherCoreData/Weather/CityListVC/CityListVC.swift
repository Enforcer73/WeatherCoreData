//
//  CityListVC.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 02.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//

import Foundation
import UIKit

class CityListVC: UIViewController {

    private let network = NetworkService.shared
    
    
    private let database = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let getCoordinate = GetCityCoordinate()
    private var nameCityesArray = [CityArrayItem]()
    
    private var arrayData = [WeatherCity]()
    private var emptyCity = WeatherCity()
    
    //MARK: - Properties

    private let tableView: UITableView = {
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configureTableView()
        configureNavigationController()
        
        getAllItems()
        checkArray()
        movingCityName()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    //MARK: - Configure Navigation

    private func configureNavigationController() {
        title = "Город"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor(named: "colorFront") //.label
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor : UIColor(named: "colorFront") ?? UIColor.self
        ]
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                         target: self,
                                         action: #selector(tappedBack))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(tappedAdd))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.style = .done
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.style = .done
    }

    //MARK: - Configure Table

    private func configureTableView() {
        tableView.backgroundColor = UIColor(named: "colorBack")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityListCell.self, forCellReuseIdentifier: "CityArrayCell")
    }

    //MARK: - Methods working with CoreData

    private func getAllItems() {
        
        do {
            self.nameCityesArray = try database.fetch(CityArrayItem.fetchRequest())
            
        } catch {
            print(error.localizedDescription)
        }
    }

    private func createItem(cityName: String) {
        let newItem = CityArrayItem(context: database)
        newItem.nameCity = cityName
        
        do {
            try database.save()
            getAllItems()
            
        } catch {
            print(error.localizedDescription )
        }
    }

    private func deleteItem(cityName: CityArrayItem) {
        database.delete(cityName)
        
        do {
            try database.save()
            getAllItems()
            
        } catch {
            print(error.localizedDescription )
        }
    }

    //MARK: - Fetching data weather

    private func checkArray() {
        if arrayData.isEmpty {
            arrayData = Array(repeating: emptyCity, count: nameCityesArray.count)
        }
    }

    private func movingCityName() {

        let cities = self.nameCityesArray.map { "\($0.nameCity ?? "")" }
        
        getCoordinate.movingCootdinateToReques(cityesArray: cities) { [weak self] index, weather in
            
            DispatchQueue.main.async {
                self?.arrayData[index] = weather
                self?.arrayData[index].nameCity = cities[index]
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - Methods Table Delegate

extension CityListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CityArrayCell", for: indexPath) as? CityListCell {
            
            cell.getData(model: arrayData[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print(indexPath.row)
    }

    //MARK: - Delete cell

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteCell = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, handler in
            
            let editCell = self?.nameCityesArray[indexPath.row]
            
            guard let cell = editCell else { return }
            
            if let index = self?.nameCityesArray.firstIndex(of: cell) {
                self?.nameCityesArray.remove(at: index)
                self?.arrayData.remove(at: index)
                self?.deleteItem(cityName: cell)
            }
            self?.tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteCell])
    }
}

//MARK: - Action

private extension CityListVC {

    //MARK: - Adding new city in array

    @objc func tappedAdd() {
        let alert = UIAlertController(title: "Добавить город", message: "Введите название города!", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Название города..."
            field.clearButtonMode = .whileEditing
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self?.createItem(cityName: text)
            
            DispatchQueue.main.async {
                self?.tappedBack()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Return to SwipingVC

    @objc func tappedBack() {
        
        let swipVC = SwipingVC()
        swipVC.modalPresentationStyle = .fullScreen
        
        present(swipVC, animated: true, completion: nil)
    }
}
