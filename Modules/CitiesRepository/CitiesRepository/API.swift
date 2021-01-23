//
//  API.swift
//  CitiesRepository
//
//  Created by Michal Jackowski on 23/01/2021.
//

import Foundation

public struct City {
    var name: String
    var imageUrl: String
}

enum RepositoryError: Error {
    case apiError
    case serializationError
}

typealias RepositoryResult = Result<[City], RepositoryError>

protocol Repository {
    func fetchData(completion: @escaping (RepositoryResult) -> ())
}
