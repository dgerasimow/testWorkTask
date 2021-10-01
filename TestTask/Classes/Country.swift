//
//  Country.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import Foundation


struct RegionElement: Decodable {
    let id: String
    let parentID: Int?
    let name: String
    let areas: [RegionElement]?
}
