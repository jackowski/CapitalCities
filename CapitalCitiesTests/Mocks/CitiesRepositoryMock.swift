//
//  CitiesRepositoryMock.swift
//  CapitalCitiesTests
//
//  Created by Michal Jackowski on 26/01/2021.
//

import Foundation
import CitiesRepository

class CitiesRepositoryMock: CitiesRepositoryProtocol {
    var getCitiesResult: Result<[City], RepositoryError>
    var getVisitorsResult: Result<[Visitor], RepositoryError>
    var getRatingResult: Result<Rating, RepositoryError>
    
    init(getCitiesResult: Result<[City], RepositoryError>,
         getVisitorsResult: Result<[Visitor], RepositoryError>,
         getRatingResult: Result<Rating, RepositoryError>) {
        self.getCitiesResult = getCitiesResult
        self.getVisitorsResult = getVisitorsResult
        self.getRatingResult = getRatingResult
    }
    
    func getCities(completion: @escaping (Result<[City], RepositoryError>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(self.getCitiesResult)
        }
    }
    
    func getVisitors(cityId: String, completion: @escaping (Result<[Visitor], RepositoryError>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(self.getVisitorsResult)
        }
    }
    
    func getRating(cityId: String, completion: @escaping (Result<Rating, RepositoryError>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(self.getRatingResult)
        }
    }
}
