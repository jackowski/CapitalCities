//
//  CityDetailsViewModel.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation
import CitiesRepository

protocol CityDetailsViewModelProtocol {
    var citiesRepository: CitiesRepository { get }
    var isDataLoading: Observable<Bool> { get }
    var navigationTitle: String { get set }
    var city: City { get set }
    var ratingText: Observable<String> { get }
    var visitorsText: Observable<String> { get }
    func viewDidAppear()
}

class CityDetailsViewModel: CityDetailsViewModelProtocol {
    var citiesRepository: CitiesRepository = CitiesRepository()
    var isDataLoading: Observable<Bool> = Observable(value: false)
    var navigationTitle: String = ""
    var city: City
    var rating: Rating?
    var visitors: [Visitor]?
    var ratingText: Observable<String> = Observable(value: "")
    var visitorsText: Observable<String> = Observable(value: "")
    
    init(city: City) {
        self.city = city
        navigationTitle = city.name
    }
    
    func viewDidAppear() {
        getAdditionalData()
    }
    
    func getAdditionalData() {
        isDataLoading.value = true
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        citiesRepository.getRating(cityId: city.cityId) { [weak self] (result) in
            switch result {
            case .success(let rating):
                self?.rating = rating
            case .failure(_):
                self?.rating = nil
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        citiesRepository.getVisitors(cityId: city.cityId) { [weak self] (result) in
            switch result {
            case .success(let visitors):
                self?.visitors = visitors
            case .failure(_):
                self?.visitors = nil
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.isDataLoading.value = false
            
            if let visitors = weakSelf.visitors {
                weakSelf.visitorsText.value = "visitors: \(visitors.count)"
            } else {
                weakSelf.visitorsText.value = "visitors: N/A"
            }
            
            if let rating = weakSelf.rating {
                weakSelf.ratingText.value = "rating: \(rating.rating)"
            } else {
                weakSelf.ratingText.value = "rating: N/A"
            }
        }
    }
}
