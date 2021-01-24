//
//  City.swift
//  CitiesRepository
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation

public struct City: Decodable {
    var name: String
    var imageUrl: String
}

public struct Visitor: Decodable {
    var name: String
}

public struct Rating: Decodable {
    var rating: Float
}
