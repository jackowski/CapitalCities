//
//  CitiesListViewModelTests.swift
//  CapitalCitiesTests
//
//  Created by Michal Jackowski on 26/01/2021.
//

import XCTest
@testable import CapitalCities
import CitiesRepository

class CitiesListViewModelTests: XCTestCase {
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
        let viewModel = CitiesListViewModel(citiesRepository: successfulCitiesRepository,
                                            favouritesRepository: favouritesRepository)
        
        XCTAssert(viewModel.citiesViewModelList.value.count == 0)
        XCTAssert(viewModel.errorMessage.value == nil)
        XCTAssert(viewModel.isDataLoading.value == false)
    }
    
    func testViewDidAppear() {
        let viewModel = CitiesListViewModel(citiesRepository: successfulCitiesRepository,
                                            favouritesRepository: favouritesRepository)
        viewModel.viewDidAppear()
        XCTAssert(viewModel.isDataLoading.value == true)
        let exp = expectation(description: "Wait for mocked async cities result")
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        XCTAssert(viewModel.isDataLoading.value == false)
        XCTAssert(viewModel.errorMessage.value == nil)
        XCTAssert(viewModel.citiesViewModelList.value.count == 3)
        XCTAssert(viewModel.citiesViewModelList.value[0].title == "Warsaw")
        XCTAssert(viewModel.citiesViewModelList.value[0].isSavedToFavourites == true)
        XCTAssert(viewModel.citiesViewModelList.value[1].title == "London")
        XCTAssert(viewModel.citiesViewModelList.value[1].isSavedToFavourites == true)
        XCTAssert(viewModel.citiesViewModelList.value[2].title == "Berlin")
        XCTAssert(viewModel.citiesViewModelList.value[2].isSavedToFavourites == false)
    }
    
    func testViewDidAppearWithApiFailure() {
        let viewModel = CitiesListViewModel(citiesRepository: failureCitiesRepository,
                                            favouritesRepository: favouritesRepository)
        viewModel.viewDidAppear()
        XCTAssert(viewModel.isDataLoading.value == true)
        let exp = expectation(description: "Wait for mocked async cities result")
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        XCTAssert(viewModel.isDataLoading.value == false)
        XCTAssert(viewModel.citiesViewModelList.value.count == 0)
        XCTAssert(viewModel.errorMessage.value == "Internal Server Error")
    }
    
    func testRetryWithApiFailure() {
        let viewModel = CitiesListViewModel(citiesRepository: failureCitiesRepository,
                                            favouritesRepository: favouritesRepository)
        viewModel.viewDidAppear()
        XCTAssert(viewModel.isDataLoading.value == true)
        let exp = expectation(description: "Wait for mocked async cities result")
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        XCTAssert(viewModel.isDataLoading.value == false)
        XCTAssert(viewModel.citiesViewModelList.value.count == 0)
        XCTAssert(viewModel.errorMessage.value == "Internal Server Error")
        
        viewModel.didTapRetry()
        XCTAssert(viewModel.isDataLoading.value == true)
        let retryExp = expectation(description: "Wait for mocked async cities result")
        _ = XCTWaiter.wait(for: [retryExp], timeout: 1.0)
        XCTAssert(viewModel.isDataLoading.value == false)
        XCTAssert(viewModel.citiesViewModelList.value.count == 0)
        XCTAssert(viewModel.errorMessage.value == "Internal Server Error")
    }
    
    func testDetailsViewModel() {
        let viewModel = CitiesListViewModel(citiesRepository: successfulCitiesRepository,
                                            favouritesRepository: favouritesRepository)
        viewModel.viewDidAppear()
        XCTAssert(viewModel.isDataLoading.value == true)
        let exp = expectation(description: "Wait for mocked async cities result")
        _ = XCTWaiter.wait(for: [exp], timeout: 1.0)
        
        let detailsViewModel = viewModel.detailsViewModel(index: 0)
        XCTAssert(detailsViewModel.city.name == "Warsaw")
        XCTAssert(detailsViewModel.city.cityId == "1")
    }
}
