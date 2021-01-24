//
//  FavouritesRepository.swift
//  FavouritesRepository
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation

class FavouritesRepository {
    var userDefaults: UserDefaults
    let favouritesKey = "favourites"
    
    var favouritesIds: [String]
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.favouritesIds = userDefaults.object(forKey: favouritesKey) as? [String] ?? []
    }
    
    public func getFavouritesIds() -> [String] {
        return self.favouritesIds
    }
    
    public func addFavouriteId(favouriteId: String) {
        guard !favouritesIds.contains(favouriteId) else {
            return
        }
        
        favouritesIds.append(favouriteId)
        synchronizeFavouritesIds()
    }
    
    public func removeFavouriteId(favouriteId: String) {
        if let index = favouritesIds.firstIndex(where: { (storedId) -> Bool in
            return storedId == favouriteId
        }) {
            favouritesIds.remove(at: index)
        }
        
        synchronizeFavouritesIds()
    }
    
    func synchronizeFavouritesIds() {
        userDefaults.set(favouritesIds, forKey: favouritesKey)
        userDefaults.synchronize()
    }
}
