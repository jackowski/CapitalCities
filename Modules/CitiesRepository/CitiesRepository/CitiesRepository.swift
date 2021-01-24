//
//  CitiesRepository.swift
//  CitiesRepository
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation

class CitiesRepository {
    var router: CitiesRouter
    
    init(router: CitiesRouter) {
        self.router = router
    }
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    func getCities(completion: @escaping (Result<[City], RepositoryError>) -> ()) {
        router.getCitiesRespose { [weak self] (response) in
            self?.hadleArrayResponse(response: response, completion: completion)
        }
    }
    
    func getVisitors(cityId: String, completion: @escaping (Result<[Visitor], RepositoryError>) -> ()) {
        router.getCiyVistorsRespose(cityId: cityId, completion: { [weak self] (response) in
            self?.hadleArrayResponse(response: response, completion: completion)
        })
    }
    
    func getRating(cityId: String, completion: @escaping (Result<Rating, RepositoryError>) -> ()) {
        router.getCiyRatingRespose(cityId: cityId, completion: { [weak self] (response) in
            self?.hadleResponse(response: response, completion: completion)
        })
    }
    
    func hadleResponse<T: Decodable>(response: Result<Data, RepositoryError>, completion: @escaping (Result<T, RepositoryError>) -> ()) {
        switch response {
        case .success(let data):
            do {
                let decodedObject: T = try self.decoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.serializationError))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func hadleArrayResponse<T: Decodable>(response: Result<Data, RepositoryError>, completion: @escaping (Result<[T], RepositoryError>) -> ()) {
        switch response {
        case .success(let data):
            do {
                let decodedObject: [T] = try self.decoder.decode([T].self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.serializationError))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
