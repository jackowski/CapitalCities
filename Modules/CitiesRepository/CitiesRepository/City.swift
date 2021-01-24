//
//  City.swift
//  CitiesRepository
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation

public struct City: Decodable {
    public var name: String
    public var imageUrl: String
}

public struct Visitor: Decodable {
    public var name: String
}

public struct Rating: Decodable {
    public var rating: Float
}
