//
//  FavouritesViewController.swift
//  Weather App
//
//  Created by Kato Drake Smith on 06/10/2022.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: - Propeties    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        return table
    }()
    
    private var models = [Cities]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getSavedCities()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        navigationItem.title = "My Favourites"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear
    }
    
    func getSavedCities() {
        OfflineData.shared.getAllCities { data in
            DispatchQueue.main.async {
                self.models = data
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        DispatchQueue.main.async {
            cell.backgroundColor = .clear
            cell.cityImage.image = IPImage(text: model.name!, radius: 25, font: nil,
                                             textColor: nil, randomBackgroundColor: true).generateImage()
            cell.cityName.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = models[indexPath.row]
        let sheet = UIAlertController(title: "Delete City",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.dismiss(animated: true)

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
            OfflineData.shared.deleteCity(city: city) { message in
                self!.view.makeToast(message, duration: 3.0, position: .bottom)
                self!.getSavedCities()
            }
        }))
        present(sheet, animated: true)
    }
}
