//
//  ViewController.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import UIKit
import SQLite

class LocationListViewController: UIViewController {

    @IBOutlet weak var locationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = LocationDatabase.sharedInstance
        LocationRequest.delegate = self
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.tableFooterView = UIView()
        locationTableView.allowsSelectionDuringEditing = true
        
        navigationItem.rightBarButtonItem = editButtonItem
        database.createCountryTable()
        database.createRegionTable()
        database.createCityTable()
        
        if database.presentRowsFromTable(requiredTable: Table("country"))!.count == 0 {
            LocationRequest().makeAPIRequest()
        }
//        database.dropAllTables()
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        locationTableView.setEditing(editing, animated: true)
    }

}

extension LocationListViewController: UITableViewDelegate{
    
}

extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SQLiteCommands.presentRowsInRegionTable(requiredTable: Table("country"))?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = locationTableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }
        let countryArray: [LocationEntityDTO] = SQLiteCommands.presentRowsInRegionTable(requiredTable: Table("country"))!
        cell.configure(name: countryArray[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if locationTableView.isEditing {
            let countryArray: [LocationEntityDTO] = SQLiteCommands.presentRowsInRegionTable(requiredTable: Table("country"))!
            guard let editingViewController = storyboard?.instantiateViewController(withIdentifier: "EditingViewController") as? EditingViewController else { return }
            editingViewController.configure(table: Table("country"), id: countryArray[indexPath.row].id)
            editingViewController.delegate = self
            present(editingViewController, animated: true)
        } else {
            
        tableView.deselectRow(at: indexPath, animated: true)
        guard let regionViewController = storyboard?.instantiateViewController(withIdentifier: "RegionViewController") as? RegionViewController else { return }
        regionViewController.configure(id: SQLiteCommands.presentRowsInRegionTable(requiredTable: Table("country"))![indexPath.row].id)
        navigationController?.pushViewController(regionViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let countryArray: [LocationEntityDTO] = SQLiteCommands.presentRowsInRegionTable(requiredTable: Table("country"))!
            SQLiteCommands.deleteSpecificRow(requiredTable: Table("country"), deleteID: countryArray[indexPath.row].id)
            locationTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension LocationListViewController: LocationListViewControllerDelegate {
    func updateView() {
        locationTableView.reloadData()
    }
}
