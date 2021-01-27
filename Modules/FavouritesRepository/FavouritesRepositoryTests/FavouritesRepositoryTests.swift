//
//  FavouritesRepositoryTests.swift
//  FavouritesRepositoryTests
//
//  Created by Michal Jackowski on 24/01/2021.
//

import XCTest
@testable import FavouritesRepository

class FavouritesRepositoryTests: XCTestCase {
    var favouritesRepository: FavouritesRepository!
    let userDefaults: UserDefaults = UserDefaults.standard

    override func setUp() {
        favouritesRepository = FavouritesRepository(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    func testNoFavouritesSaved() {
        XCTAssert(favouritesRepository.getFavouritesIds().count == 0)
    }
    
    func testAddFavourite() {
        favouritesRepository.addFavouriteId(favouriteId: "1")
        XCTAssert(favouritesRepository.getFavouritesIds().count == 1)
    }
    
    func testRemovingFavourite() {
        favouritesRepository.addFavouriteId(favouriteId: "1")
        favouritesRepository.removeFavouriteId(favouriteId: "1")
        XCTAssert(favouritesRepository.getFavouritesIds().count == 0)
    }
    
    func testAddingSameFavouriteMultipleTimes() {
        favouritesRepository.addFavouriteId(favouriteId: "1")
        favouritesRepository.addFavouriteId(favouriteId: "1")
        favouritesRepository.addFavouriteId(favouriteId: "1")
        favouritesRepository.addFavouriteId(favouriteId: "1")
        XCTAssert(favouritesRepository.getFavouritesIds().count == 1)
    }
    
    func testRemovingNotStoredItem() {
        favouritesRepository.removeFavouriteId(favouriteId: "1")
        XCTAssert(favouritesRepository.getFavouritesIds().count == 0)
    }
}
