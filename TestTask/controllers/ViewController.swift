//
//  ViewController.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import UIKit
import SQLite

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
//        print(apiRequest.getRegionRequest())
        let database = RegionDatabase.sharedInstance
        database.createTable(table: Table("Region"))
        database.createTable(table: Table("Country"))
        database.createTable(table: Table("City"))
        
    }

    
    // MARK: -


}

