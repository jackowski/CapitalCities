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
    var isDataLoading: Observable<Bool> { get }
    var citiesList: Observable<[CityItemViewModel]> { get }
    func viewDidAppear()
}

class CitiesListViewModel: CitiesListViewModelProtocol {
    let citiesRepository: CitiesRepository = CitiesRepository()
    let isDataLoading: Observable<Bool> = Observable(value: false)
    let citiesList: Observable<[CityItemViewModel]> = Observable(value: [])
    
    func viewDidAppear() {
        getCities()
    }
    
    fileprivate func getCities() {
        isDataLoading.value = true
        citiesRepository.getCities { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
                case .success(let cities):
                    weakSelf.citiesList.value = cities.map { CityItemViewModel(title: $0.name) }
                    weakSelf.isDataLoading.value = false
                case .failure(_):
                    weakSelf.isDataLoading.value = false
            }
        }
    }
}
