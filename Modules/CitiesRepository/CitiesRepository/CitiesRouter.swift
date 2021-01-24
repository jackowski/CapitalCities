//
//  CitiesRouter.swift
//  CitiesRepository
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation

protocol CitiesRouter {
    func getCitiesRespose(completion: @escaping (Result<Data, RepositoryError>) -> ())
    func getCiyVistorsRespose(cityId: String, completion: @escaping (Result<Data, RepositoryError>) -> ())
    func getCiyRatingRespose(cityId: String, completion: @escaping (Result<Data, RepositoryError>) -> ())
}

class CitiesAPIRouter: CitiesRouter {
    func getCitiesRespose(completion: @escaping (Result<Data, RepositoryError>) -> ()) {
        let url = URL(string: "https://gist.githubusercontent.com/jackowski/66d1655194bbfcf9affb5206b6b334e5/raw/bb5610d32c32dfd1fb88d7c97cc6dcc08d23d1a9/capital_cities.json")!
        return getDataFromUrl(url: url, completion: completion)
    }
    
    func getCiyVistorsRespose(cityId: String, completion: @escaping (Result<Data, RepositoryError>) -> ()) {
        let url = URL(string: "https://gist.githubusercontent.com/jackowski/484de862d7096784471a35d7c2585bf8/raw/ac76d47effecc79f397c1ef4154d5f9bfd5c9e33/visitors.json")!
        return getDataFromUrl(url: url, completion: completion)
    }
    
    func getCiyRatingRespose(cityId: String, completion: @escaping (Result<Data, RepositoryError>) -> ()) {
        let url = URL(string: "https://gist.githubusercontent.com/jackowski/48c7d080516ea340d1de2ae54d39bfb4/raw/b781fee2f873aaca618ab29a60459475e467e7ef/rating.json")!
        return getDataFromUrl(url: url, completion: completion)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Result<Data, RepositoryError>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode),
                let data = data else {
                completion(.failure(.apiError))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
}
