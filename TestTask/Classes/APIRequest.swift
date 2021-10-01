//
//  APIRequest.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import Foundation
import SQLite

struct RegionRequest {
    let url: URL
    var request: URLRequest
    init() {
        url = URL(string: "https://api.hh.ru/areas")!
        request = URLRequest(url: url)
    }

    
    mutating func getRegionRequest() -> [RegionElement] {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, repsonse, error in
            guard let data = data else {
                if let error = error {
                    print("HTTP Request failed \(error)")
                    return
                }
                return
            }
            
            guard let regions = try? JSONDecoder().decode([RegionElement].self, from: data) else {
                print("Invalid response")
                return
            }
        }
        dataTask.resume()
        let db = try Connection
    }
}
