//
//  FavouritesRepositoryMock.swift
//  CapitalCitiesTests
//
//  Created by Michal Jackowski on 26/01/2021.
//

import Foundation
import FavouritesRepository

class FavouritesRepositoryMock: FavouritesRepositoryProtocol {
    var favouritesIds: [String]
    init(favouritesIds: [String]) {
        self.favouritesIds = favouritesIds
    }
    
    func getFavouritesIds() -> [String] {
        return favouritesIds
    }
    
    func addFavouriteId(favouriteId: String) {}
    
    func removeFavouriteId(favouriteId: String) {}

}
