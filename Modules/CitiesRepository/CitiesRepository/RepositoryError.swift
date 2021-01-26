//
//  API.swift
//  CitiesRepository
//
//  Created by Michal Jackowski on 23/01/2021.
//

import Foundation

public enum RepositoryError: Error {
    case apiError
    case serializationError
    case noInternetConnection
}
