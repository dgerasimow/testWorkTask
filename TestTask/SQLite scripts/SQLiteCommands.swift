//
//  RegionTableCreation.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import Foundation
import SQLite

class SQLiteCommands {
    static var regionTable = Table("Region")
    static var countryTable = Table("Country")
    static var cityTable = Table("City")
    
    //expressions
    static let id = Expression<String>("id")
    static let parent_id = Expression<String>("parent_id")
    static let name = Expression<String>("name")
    
    //creating region table
    static func createTable(requiredTable: Table) {
        guard let database = RegionDatabase.sharedInstance.database else {
            print("Something wrong with database connection :( Check your settings")
            return
        }
        //ifNotExists: true - will not create a table if it already exists
        do {
            try database.run(requiredTable.create(ifNotExists: true) { table in
                table.column(id)
                table.column(parent_id)
                table.column(name)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    static func insertRowIntoRegionTable(_ locationValues: LocationEntityDTO, requiredTable: Table) -> Bool? {
        guard let database = RegionDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(requiredTable.insert(id <- locationValues.id, parent_id <- locationValues.parentID, name <- locationValues.name))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    //Present rows
    static func presentRowsInRegionTable(requiredTable: Table) -> [LocationEntityDTO]? {
        guard let database = RegionDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        var locationArray = [LocationEntityDTO]()
        
        //sorting data in descending order by id
        let table = requiredTable.order(id.desc)
        
        do {
            for region in try database.prepare(table) {
                let idValue = region[id]
                let parentID = region[parent_id]
                let regionName = region[name]
                
                //Create object
                let locationObject = LocationEntityDTO(id: idValue, parentID: parentID, name: regionName)
                
                //add to an array
                locationArray.append(locationObject)
                print("id: \(region[id]), parentID: \(region[parent_id]), name: \(region[name])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        return locationArray
    }
}
