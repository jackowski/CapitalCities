//
//  FavouritesRepository.swift
//  FavouritesRepository
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation

public protocol FavouritesRepositoryProtocol {
    func getFavouritesIds() -> [String]
    func addFavouriteId(favouriteId: String)
    func removeFavouriteId(favouriteId: String)
}

public class FavouritesRepository: FavouritesRepositoryProtocol {
    fileprivate var userDefaults: UserDefaults
    fileprivate let favouritesKey = "favourites"
    
    fileprivate var favouritesIds: [String]
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.favouritesIds = userDefaults.object(forKey: favouritesKey) as? [String] ?? []
    }
    
    public convenience init() {
        self.init(userDefaults: UserDefaults.standard)
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
    
    fileprivate func synchronizeFavouritesIds() {
        userDefaults.set(favouritesIds, forKey: favouritesKey)
        userDefaults.synchronize()
    }
}
