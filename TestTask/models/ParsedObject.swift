//
//  Country.swift
//  TestTask
//
//  Created by Danil Gerasimov on 01.10.2021.
//

import UIKit


struct ParsedObject: Decodable {
    let id: String
    let parent_id: String?
    let name: String
    let areas: [ParsedObject]
}
