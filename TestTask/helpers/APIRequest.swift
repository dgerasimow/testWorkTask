//
//  APIRequest.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import Foundation
import SQLite

class RegionRequest {
    let url: URL
    var request: URLRequest
    init() {
        url = URL(string: "https://api.hh.ru/areas")!
        request = URLRequest(url: url)
    }

    
    func getRegionRequest(completion: @escaping ([ParsedObject]?) -> Void) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, repsonse, error) in
            if let data = data {
                do {
                let regions = try JSONDecoder().decode([ParsedObject].self, from: data)
//                    print(regions)
                    completion(regions)
                } catch {
                    print("Invalid response: \(error)")
                    completion(nil)
                }
            } else if let error = error {
                print("HTTP Request failed \(error)")
                completion(nil)
            }
        }
        dataTask.resume()
        

    }
    
    
    
    private func addApiResponseDataToDatabase() {
        
        //adding api response data
        getRegionRequest { region in
            self.save(parsedDataArray: region!, c: 0)
        }
        
    }
    
    func save(parsedDataArray: [ParsedObject], c: Int) {
        var counter = c
        counter += 1
        for obj in parsedDataArray {
            switch counter {
            case 1:
                RegionDatabase.sharedInstance.insertData(table: Table("Country"), locationValues: LocationEntityDTO(id: obj.id, parentID: obj.parentID!, name: obj.name))
                save(parsedDataArray: obj.areas, c: counter)
            case 2:
                RegionDatabase.sharedInstance.insertData(table: Table("Region"), locationValues: LocationEntityDTO(id: obj.id, parentID: obj.parentID!, name: obj.name))
                save(parsedDataArray: obj.areas, c: counter)
            case 3:
                RegionDatabase.sharedInstance.insertData(table: Table("City"), locationValues: LocationEntityDTO(id: obj.id, parentID: obj.parentID!, name: obj.name))
            default:
                return
            }
        }
    }
}
