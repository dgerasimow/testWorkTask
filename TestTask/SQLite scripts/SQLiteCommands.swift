//
//  RegionTableCreation.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import Foundation
import SQLite

class SQLiteCommands {
    static var regionTable = Table("region")
    static var countryTable = Table("country")
    static var cityTable = Table("city")
    
    //expressions
    static let id = Expression<String>("id")
    static let parent_id = Expression<String>("parent_id")
    static let name = Expression<String>("name")
    
    //creating region table
    static func createRegionTable() {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Something wrong with database connection :( Check your settings")
            return
        }
        //ifNotExists: true - will not create a table if it already exists

        do {
            try database.run(regionTable.create(ifNotExists: true) { table in
                table.column(id)
                table.column(parent_id)
                table.column(name)
                
                table.foreignKey(parent_id, references: countryTable, id)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    //creating country table
    static func createCountryTable() {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Something wrong with database connection :( Check your settings")
            return
        }
        //ifNotExists: true - will not create a table if it already exists

        do {
            try database.run(countryTable.create(ifNotExists: true) { table in
                table.column(id)
                table.column(parent_id)
                table.column(name)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    //creating city table
    static func createCityTable() {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Something wrong with database connection :( Check your settings")
            return
        }
        //ifNotExists: true - will not create a table if it already exists

        do {
            try database.run(cityTable.create(ifNotExists: true) { table in
                table.column(id)
                table.column(parent_id)
                table.column(name)
                
                table.foreignKey(parent_id, references: regionTable, id)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    static func insertRowIntoLocationTable(_ locationValues: LocationEntityDTO, requiredTable: Table) -> Bool? {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(requiredTable.insert(id <- locationValues.id, parent_id <- locationValues.parent_id, name <- locationValues.name))
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
        guard let database = LocationDatabase.sharedInstance.database else {
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
                let locationObject = LocationEntityDTO(id: idValue, parent_id: parentID, name: regionName)
                
                //add to an array
                locationArray.append(locationObject)

            }
        } catch {
            print("Present row error: \(error)")
        }
        return locationArray
    }
    
    //select specific row
    static func selectSpecificRowByID(requiredTable: Table, id: String) -> LocationEntityDTO? {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        let table = requiredTable.where(self.id == id)
        
        var locationObject: LocationEntityDTO? = nil
        do{
            for row in try database.prepare(table) {
                let idValue = row[self.id]
                let parentID = row[parent_id]
                let name = row[name]
                
                locationObject = LocationEntityDTO(id: idValue, parent_id: parentID, name: name)
            }
        } catch {
            print("Selection error: \(error)")
        }
        return locationObject
    }
    
    //select all specific rows
    static func selectAllSpecificRowByID(requiredTable: Table, id: String) -> [LocationEntityDTO]? {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        let table = requiredTable.where(self.id == id)
        var regionsArray = [LocationEntityDTO]()
        
        do {
            for row in try database.prepare(table) {
                let idValue = row[self.id]
                let parentID = row[parent_id]
                let name = row[name]
                
                let regionObject = LocationEntityDTO(id: idValue, parent_id: parentID, name: name)
                
                regionsArray.append(regionObject)
            }
        } catch {
            print("Selection error: \(error)")
        }
        return regionsArray
    }
    // by parrentID
    static func selectAllSpecificRowByParentID(requiredTable: Table, id: String) -> [LocationEntityDTO]? {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        let table = requiredTable.where(parent_id == id)
        
        var regionsArray = [LocationEntityDTO]()
        
        do {
            for row in try database.prepare(table) {
                let idValue = row[self.id]
                let parentID = row[parent_id]
                let name = row[name]
                
                let regionObject = LocationEntityDTO(id: idValue, parent_id: parentID, name: name)
                
                regionsArray.append(regionObject)
            }
        } catch {
            print("Selection error: \(error)")
        }
        return regionsArray
    }
    
    //delete rows
    static func deleteAllRowsInTable() {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
        try database.run(regionTable.delete())
        try database.run(countryTable.delete())
        try database.run(cityTable.delete())
        } catch {
            print("delete failed: \(error)")
        }
    }
    
    //delete specific row
    static func deleteSpecificRow(requiredTable: Table, deleteID: String) {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            try database.run(requiredTable.where(id == deleteID).delete())
        } catch {
            print("delete failed: \(error)")
        }
    }
    
    static func dropAllTables() {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
        try database.run(regionTable.drop())
        try database.run(countryTable.drop())
        try database.run(cityTable.drop())
        } catch {
            print("delete failed: \(error)")
        }
    }
    
    //update rows
    static func updateNameInRows(requiredTable: Table, newName: String, id: String) {
        guard let database = LocationDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            try database.run(requiredTable.where(self.id == id).update(name <- newName))
        } catch {
            print("update failed: \(error)")
        }
    }
}
