//
//  CitiesRepositoryTests.swift
//  CitiesRepositoryTests
//
//  Created by Michal Jackowski on 23/01/2021.
//

import XCTest
@testable import CitiesRepository

class CitiesRepositoryTests: XCTestCase {
    
    class CitiesMockedRouter: CitiesRouter {
        func getCitiesRespose(completion: @escaping (Result<Data, RepositoryError>) -> ()) {
            let path = Bundle(for: type(of: self)).path(forResource: "Cities", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            completion(.success(data))
        }
        
        func getCiyVistorsRespose(cityId: String, completion: @escaping (Result<Data, RepositoryError>) -> ()) {
            let path = Bundle(for: type(of: self)).path(forResource: "Visitors", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            completion(.success(data))
        }
        
        func getCiyRatingRespose(cityId: String, completion: @escaping (Result<Data, RepositoryError>) -> ()) {
            let path = Bundle(for: type(of: self)).path(forResource: "Rating", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            completion(.success(data))
        }
    }
    
    var citiesRepository: CitiesRepository!

    override func setUp() {
        citiesRepository = CitiesRepository(router: CitiesMockedRouter())
    }
    
    func testSuccessfullGetCities() {
        var repositoryResult: Result<[City], RepositoryError>? = nil
        citiesRepository.getCities { (result) in
            repositoryResult = result
        }
        
        switch repositoryResult! {
        case .success(let cities):
            XCTAssert(cities.count == 7, "number of cities should be 6")
            XCTAssert(cities[0].cityId == "1", "city id should be 1")
            XCTAssert(cities[0].name == "Warsaw", "city name should be Warsaw")
            XCTAssert(cities[0].imageUrl == "")
        case .failure(_):
            XCTFail("should have success result")
        }
    }
    
    func testSuccessfullGetVisitors() {
        var repositoryResult: Result<[Visitor], RepositoryError>? = nil
        citiesRepository.getVisitors(cityId: "", completion: { (result) in
            repositoryResult = result
        })
        
        switch repositoryResult! {
        case .success(let cities):
            XCTAssert(cities.count == 6, "number of visitors should be 6")
            XCTAssert(cities[0].name == "John Snow", "visitor name should be John Snow")
        case .failure(_):
            XCTFail("should have success result")
        }
    }
    
    func testSuccessfullGetRating() {
        var repositoryResult: Result<Rating, RepositoryError>? = nil
        citiesRepository.getRating(cityId: "", completion: { (result) in
            repositoryResult = result
        })
        
        switch repositoryResult! {
        case .success(let rating):
            XCTAssert(rating.rating == 9.5, "rating value should be 9.5")
        case .failure(_):
            XCTFail("should have success result")
        }
    }
}
