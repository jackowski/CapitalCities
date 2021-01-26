//
//  CityDetailsViewModel.swift
//  CapitalCitiesTests
//
//  Created by Michal Jackowski on 27/01/2021.
//

import XCTest
@testable import CapitalCities
import CitiesRepository

class CityDetailsViewModelTests: XCTestCase {
    var successfulCitiesRepository: CitiesRepositoryMock!
    var failureCitiesRepository: CitiesRepositoryMock!
    var favouritesRepository: FavouritesRepositoryMock!
    
    override func setUp() {
        let mockedCities = [
            City(cityId: "1", name: "Warsaw", imageUrl: ""),
            City(cityId: "2", name: "London", imageUrl: ""),
            City(cityId: "3", name: "Berlin", imageUrl: "")
        ]
        
        let mockedVisitors = [
            Visitor(name: "Visitor 1"),
            Visitor(name: "Visitor 2")
        ]
        
        let rating = Rating(rating: 9.5)
        
        successfulCitiesRepository = CitiesRepositoryMock(getCitiesResult: .success(mockedCities),
                                                          getVisitorsResult: .success(mockedVisitors),
                                                          getRatingResult: .success(rating))
        
        failureCitiesRepository = CitiesRepositoryMock(getCitiesResult: .failure(.apiError),
                                                       getVisitorsResult: .failure(.apiError),
                                                       getRatingResult: .failure(.apiError))
        
        favouritesRepository = FavouritesRepositoryMock(favouritesIds: ["1", "2"])
    }
    
    func testInitialState() {
        let city = City(cityId: "1", name: "Warsaw", imageUrl: "url")
        let completion: (() -> ()) = {}
        let viewModel = CityDetailsViewModel(citiesRepository: successfulCitiesRepository,
                                             favouritesRepository: favouritesRepository,
                                             city: city,
                                             isSavedInFavourites: true,
                                             didChangeSaveToFavourites: completion)
        
        XCTAssert(viewModel.navigationTitle == "Warsaw")
        XCTAssert(viewModel.imageUrl == "url")
        XCTAssert(viewModel.isDataLoading.value == false)
        XCTAssert(viewModel.favouriteButtonTitle.value == "Remove From Favourites")
        XCTAssert(viewModel.visitorsText.value == "")
        XCTAssert(viewModel.ratingText.value == "")
    }
    
    func testViewDidAppear() {
        let city = City(cityId: "1", name: "Warsaw", imageUrl: "url")
        let completion: (() -> ()) = {}
        let viewModel = CityDetailsViewModel(citiesRepository: successfulCitiesRepository,
                                             favouritesRepository: favouritesRepository,
                                             city: city,
                                             isSavedInFavourites: true,
                                             didChangeSaveToFavourites: completion)
        
        viewModel.viewDidAppear()
        XCTAssert(viewModel.isDataLoading.value == true)
        let exp = expectation(description: "Wait for mocked async visitors and ranking result")
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        XCTAssert(viewModel.visitorsText.value == "visitors: 2")
        XCTAssert(viewModel.ratingText.value == "rating: 9.5")
    }
    
    func testViewDidAppearWithFailure() {
        let city = City(cityId: "1", name: "Warsaw", imageUrl: "url")
        let completion: (() -> ()) = {}
        let viewModel = CityDetailsViewModel(citiesRepository: failureCitiesRepository,
                                             favouritesRepository: favouritesRepository,
                                             city: city,
                                             isSavedInFavourites: true,
                                             didChangeSaveToFavourites: completion)
        
        viewModel.viewDidAppear()
        XCTAssert(viewModel.isDataLoading.value == true)
        let exp = expectation(description: "Wait for mocked async visitors and ranking result")
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        XCTAssert(viewModel.visitorsText.value == "visitors: N/A")
        XCTAssert(viewModel.ratingText.value == "rating: N/A")
    }
    
    func testRemoveAndAddToFavourites() {
        let city = City(cityId: "1", name: "Warsaw", imageUrl: "url")
        let completion: (() -> ()) = {}
        let viewModel = CityDetailsViewModel(citiesRepository: failureCitiesRepository,
                                             favouritesRepository: favouritesRepository,
                                             city: city,
                                             isSavedInFavourites: true,
                                             didChangeSaveToFavourites: completion)
        
        XCTAssert(viewModel.favouriteButtonTitle.value == "Remove From Favourites")
        viewModel.didTapSaveToFavouritesButton()
        XCTAssert(viewModel.favouriteButtonTitle.value == "Save To Favourites")
        viewModel.didTapSaveToFavouritesButton()
        XCTAssert(viewModel.favouriteButtonTitle.value == "Remove From Favourites")
    }
    
    func testGetVisitorsViewModel() {
        let city = City(cityId: "1", name: "Warsaw", imageUrl: "url")
        let completion: (() -> ()) = {}
        let viewModel = CityDetailsViewModel(citiesRepository: successfulCitiesRepository,
                                             favouritesRepository: favouritesRepository,
                                             city: city,
                                             isSavedInFavourites: true,
                                             didChangeSaveToFavourites: completion)
        viewModel.viewDidAppear()
        let exp = expectation(description: "Wait for mocked async visitors and ranking result")
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        let visitorsViewModel = viewModel.visitorsListViewModel()
        XCTAssert(visitorsViewModel.visitorListTitles.count == 2)
        XCTAssert(visitorsViewModel.visitorListTitles[0] == "Visitor 1")
        XCTAssert(visitorsViewModel.visitorListTitles[1] == "Visitor 2")
    }

}
