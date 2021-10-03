//
//  APIRequest.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import UIKit
import SQLite

protocol LocationListViewControllerDelegate: AnyObject {
    func updateView()
}

class LocationRequest {
    let url: URL
    var request: URLRequest
    static weak var delegate: LocationListViewControllerDelegate?
    init() {
        url = URL(string: "https://api.hh.ru/areas")!
        request = URLRequest(url: url)
    }

    func makeAPIRequest() {
        addApiResponseDataToDatabase()
    }
    
    private func getAPIRequest(completion: @escaping ([ParsedObject]?) -> Void) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, repsonse, error) in
            if let data = data {
                do {
                let regions = try JSONDecoder().decode([ParsedObject].self, from: data)
//                    print(regions[0].areas[0].id)
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
        getAPIRequest { region in
            self.save(parsedDataArray: region!, c: 0)
            DispatchQueue.main.async {
                LocationRequest.delegate?.updateView()
            }
        
        }
        
    }
    
    func save(parsedDataArray: [ParsedObject], c: Int) {
        var counter = c
        counter += 1
        for obj in parsedDataArray {
            switch counter {
            case 1:
                LocationDatabase.sharedInstance.insertData(table: Table("country"), locationValues: LocationEntityDTO(id: obj.id, parent_id: obj.parent_id ?? "", name: obj.name))
                save(parsedDataArray: obj.areas, c: counter)
            case 2:                
                LocationDatabase.sharedInstance.insertData(table: Table("region"), locationValues: LocationEntityDTO(id: obj.id, parent_id: obj.parent_id ?? "" , name: obj.name))
                save(parsedDataArray: obj.areas, c: counter)
            case 3:
                LocationDatabase.sharedInstance.insertData(table: Table("city"), locationValues: LocationEntityDTO(id: obj.id, parent_id: obj.parent_id ?? "", name: obj.name))
            default:
                return
            }
        }
    }
}
