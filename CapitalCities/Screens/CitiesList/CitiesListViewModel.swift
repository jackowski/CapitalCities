//
//  CitiesListViewModel.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation
import CitiesRepository
import FavouritesRepository

struct CityItemViewModel {
    var title: String
    var isSavedToFavourites: Bool
}

protocol CitiesListViewModelProtocol {
    var citiesRepository: CitiesRepository { get }
    var favouritesRepository: FavouritesRepository { get }
    var cities: [City] { get set }
    var isDataLoading: Observable<Bool> { get }
    var citiesViewModelList: Observable<[CityItemViewModel]> { get }
    func viewDidAppear()
    func detailsViewModel(index: Int) -> CityDetailsViewModelProtocol
}

class CitiesListViewModel: CitiesListViewModelProtocol {
    let citiesRepository: CitiesRepository = CitiesRepository()
    let favouritesRepository: FavouritesRepository = FavouritesRepository()
    let isDataLoading: Observable<Bool> = Observable(value: false)
    let citiesViewModelList: Observable<[CityItemViewModel]> = Observable(value: [])
    
    var cities: [City] = [] {
        didSet {
            updateCitiesViewModel()
        }
    }
    
    func updateCitiesViewModel() {
        citiesViewModelList.value = cities.map {
            CityItemViewModel(title: $0.name,
                              isSavedToFavourites: favouritesRepository.getFavouritesIds().contains($0.cityId))
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
        let isSavedToFavourites = citiesViewModelList.value[index].isSavedToFavourites
        return CityDetailsViewModel(favouritesRepository: favouritesRepository,
                                    city: city,
                                    isSavedInFavourites: isSavedToFavourites,
                                    didChangeSaveToFavourites: { [weak self] in
                                        self?.updateCitiesViewModel()
        })
    }
}
