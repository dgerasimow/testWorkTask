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
        
    }
    
    func configure(id: String) {
        parentID = id
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
    }
    
}
