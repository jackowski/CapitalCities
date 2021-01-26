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
    var imageUrl: String
    var isSavedToFavourites: Bool
}

protocol CitiesListViewModelProtocol {
    var citiesRepository: CitiesRepositoryProtocol { get }
    var favouritesRepository: FavouritesRepositoryProtocol { get }
    var cities: [City] { get set }
    var isDataLoading: Observable<Bool> { get }
    var errorMessage: Observable<String?> { get }
    var citiesViewModelList: Observable<[CityItemViewModel]> { get }
    func viewDidAppear()
    func didTapRetry()
    func detailsViewModel(index: Int) -> CityDetailsViewModelProtocol
}

class CitiesListViewModel: CitiesListViewModelProtocol {
    var citiesRepository: CitiesRepositoryProtocol
    var favouritesRepository: FavouritesRepositoryProtocol
    let isDataLoading: Observable<Bool> = Observable(value: false)
    var errorMessage: Observable<String?> = Observable(value: nil)
    let citiesViewModelList: Observable<[CityItemViewModel]> = Observable(value: [])
    
    init(citiesRepository: CitiesRepositoryProtocol,
         favouritesRepository: FavouritesRepositoryProtocol) {
        self.citiesRepository = citiesRepository
        self.favouritesRepository = favouritesRepository
    }
    
    var cities: [City] = [] {
        didSet {
            updateCitiesViewModel()
        }
    }
    
    func updateCitiesViewModel() {
        citiesViewModelList.value = cities.map {
            CityItemViewModel(title: $0.name,
                              imageUrl: $0.imageUrl,
                              isSavedToFavourites: favouritesRepository.getFavouritesIds().contains($0.cityId))
        }
    }
    
    func viewDidAppear() {
        getCities()
    }
    
    fileprivate func getCities() {
        isDataLoading.value = true
        citiesRepository.getCities { [unowned self] (result) in
            switch result {
                case .success(let cities):
                    self.cities = cities
                    self.isDataLoading.value = false
                case .failure(let error):
                    self.isDataLoading.value = false
                    self.errorMessage.value = error.message()
            }
        }
    }
    
    func didTapRetry() {
        getCities()
    }
    
    func detailsViewModel(index: Int) -> CityDetailsViewModelProtocol {
        let city = cities[index]
        let isSavedToFavourites = citiesViewModelList.value[index].isSavedToFavourites
        return CityDetailsViewModel(citiesRepository: self.citiesRepository,
                                    favouritesRepository: self.favouritesRepository,
                                    city: city,
                                    isSavedInFavourites: isSavedToFavourites,
                                    didChangeSaveToFavourites: { [weak self] in
                                        self?.updateCitiesViewModel()
        })
    }
}
