//
//  RegionViewController.swift
//  TestTask
//
//  Created by Danil Gerasimov on 03.10.2021.
//

import UIKit
import SQLite

class RegionViewController: UIViewController {

    @IBOutlet weak var regionTableView: UITableView!
    var parentID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = LocationDatabase.sharedInstance
        
        guard let parentObject = database.selectSpecificRowByID(requiredTable: Table("country"), id:parentID) else { return }
        self.title = parentObject.name
        
        
        regionTableView.tableFooterView = UIView()
        regionTableView.dataSource = self
        regionTableView.delegate = self
        
    }
    
    func configure(id: String) {
        parentID = id
    }

}

extension RegionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let regions = SQLiteCommands.selectAllSpecificRowByParentID(requiredTable: Table("region"), id: parentID) else { return 0 }
        return regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = regionTableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as? RegionTableViewCell else { return UITableViewCell() }
        guard let regions = SQLiteCommands.selectAllSpecificRowByParentID(requiredTable: Table("region"), id: parentID) else { return UITableViewCell()}
        cell.configure(name: regions[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        regionTableView.deselectRow(at: indexPath, animated: true)
        
        guard let cityViewController = storyboard?.instantiateViewController(withIdentifier: "CityViewController") as? CityViewController else { return }
        guard let regions = SQLiteCommands.selectAllSpecificRowByParentID(requiredTable: Table("region"), id: parentID) else { return }
        guard let checkCities = SQLiteCommands.selectAllSpecificRowByParentID(requiredTable: Table("city"), id: regions[indexPath.row].id) else { return }
        
        if checkCities.count == 0 {
            let alert = UIAlertController(title: "Упс..", message: "Нет информации по городам этого региона :(", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Назад", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
        cityViewController.configure(id: regions[indexPath.row].id)
        navigationController?.pushViewController(cityViewController, animated: true)
    }
    
    
    
}
