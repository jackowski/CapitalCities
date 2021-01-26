//
//  City.swift
//  CitiesRepository
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation

public struct City: Decodable {
    public var cityId: String
    public var name: String
    public var imageUrl: String
    
    public init(cityId: String,
                name: String,
                imageUrl: String) {
        self.cityId = cityId
        self.name = name
        self.imageUrl = imageUrl
    }
}

public struct Visitor: Decodable {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct Rating: Decodable {
    public var rating: Float
    
    public init(rating: Float) {
        self.rating = rating
    }
}
