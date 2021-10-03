//
//  RegionDatabase.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import Foundation
import SQLite

class LocationDatabase {
    static let sharedInstance = LocationDatabase()
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
    func createCountryTable() {
        SQLiteCommands.createCountryTable()
    }
    
    func createRegionTable() {
        SQLiteCommands.createRegionTable()
    }
    
    func createCityTable() {
        SQLiteCommands.createCityTable()
    }
    
    func insertData(table: Table, locationValues: LocationEntityDTO) {
        SQLiteCommands.insertRowIntoLocationTable(locationValues, requiredTable: table)
    }
    
    func deleteAllDataFromTable() {
        SQLiteCommands.deleteAllRowsInTable()
    }
    
    func dropAllTables() {
        SQLiteCommands.dropAllTables()
    }
    
    func presentRowsFromTable(requiredTable: Table) -> [LocationEntityDTO]? {
        return SQLiteCommands.presentRowsInRegionTable(requiredTable: requiredTable)
    }
    
    func selectSpecificRowByID(requiredTable: Table, id: String) -> LocationEntityDTO? {
        return SQLiteCommands.selectSpecificRowByID(requiredTable: requiredTable, id: id)
    }
}
