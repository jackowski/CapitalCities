//
//  CitiesListViewModel.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation
import CitiesRepository

struct CityItemViewModel {
    var title: String
}

protocol CitiesListViewModelProtocol {
    var citiesRepository: CitiesRepository { get }
    var cities: [City] { get set }
    var isDataLoading: Observable<Bool> { get }
    var citiesViewModelList: Observable<[CityItemViewModel]> { get }
    func viewDidAppear()
    func detailsViewModel(index: Int) -> CityDetailsViewModelProtocol
}

class CitiesListViewModel: CitiesListViewModelProtocol {
    let citiesRepository: CitiesRepository = CitiesRepository()
    let isDataLoading: Observable<Bool> = Observable(value: false)
    let citiesViewModelList: Observable<[CityItemViewModel]> = Observable(value: [])
    
    var cities: [City] = [] {
        didSet {
            citiesViewModelList.value = cities.map { CityItemViewModel(title: $0.name) }
        }
    }
    
    func viewDidAppear() {
        getCities()
    }
    
    fileprivate func getCities() {
        isDataLoading.value = true
        citiesRepository.getCities { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
                case .success(let cities):
                    weakSelf.cities = cities
                    weakSelf.isDataLoading.value = false
                case .failure(_):
                    weakSelf.isDataLoading.value = false
            }
        }
    }
    
    func detailsViewModel(index: Int) -> CityDetailsViewModelProtocol {
        let city = cities[index]
        return CityDetailsViewModel(city: city)
    }
}
