//
//  RegionDatabase.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import Foundation
import SQLite

class RegionDatabase {
    static let sharedInstance = RegionDatabase()
    var database: Connection?

    private init() {
        //conection to db
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("regions").appendingPathExtension("sqlite3")
            
            database = try Connection(fileUrl.path)
        } catch {
            print("Connection to database failed. Reason: \(error)")
        }
    }
    //table creating
    func createTable(table: Table) {
        SQLiteCommands.createTable(requiredTable: table)
    }
    
    func insertData(table: Table, locationValues: LocationEntityDTO) {
        SQLiteCommands.insertRowIntoRegionTable(locationValues, requiredTable: table)
    }
}
