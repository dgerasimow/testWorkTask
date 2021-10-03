//
//  CityViewController.swift
//  TestTask
//
//  Created by Danil Gerasimov on 03.10.2021.
//

import UIKit
import SQLite

class CityViewController: UIViewController {

    @IBOutlet weak var cityTableView: UITableView!
    var parentID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database = LocationDatabase.sharedInstance
        
        guard let parentObject = database.selectSpecificRowByID(requiredTable: Table("region"), id:parentID) else { return }
        self.title = parentObject.name
        
        
        cityTableView.tableFooterView = UIView()
        cityTableView.dataSource = self
        cityTableView.delegate = self
        cityTableView.allowsSelectionDuringEditing = true
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    func configure(id: String) {
        parentID = id
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        cityTableView.setEditing(editing, animated: true)
    }

}

extension CityViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cities = SQLiteCommands.selectAllSpecificRowByParentID(requiredTable: Table("city"), id: parentID) else { return 0 }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cityTableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        guard let cities = SQLiteCommands.selectAllSpecificRowByParentID(requiredTable: Table("city"), id: parentID) else { return UITableViewCell()}
        cell.configure(name: cities[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityTableView.deselectRow(at: indexPath, animated: true)
        if cityTableView.isEditing {
            guard let cityArray = SQLiteCommands.selectAllSpecificRowByParentID(requiredTable: Table("city"), id: parentID) else { return }
            guard let editingViewController = storyboard?.instantiateViewController(withIdentifier: "EditingViewController") as? EditingViewController else { return }
            editingViewController.configure(table: Table("city"), id: cityArray[indexPath.row].id)
            editingViewController.cityDelegate = self
            present(editingViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let regionArray = SQLiteCommands.selectAllSpecificRowByParentID(requiredTable: Table("city"), id: parentID) else { return }
            SQLiteCommands.deleteSpecificRow(requiredTable: Table("city"), deleteID: regionArray[indexPath.row].id)
            cityTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
extension CityViewController: CityViewControllerDelegate {
    func updateView() {
        cityTableView.reloadData()
    }
}
