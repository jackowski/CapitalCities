//
//  VisitorsListViewModel.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 25/01/2021.
//

import Foundation
import CitiesRepository

protocol VisitorsListViewModelProtocol {
    var visitorListTitles: [String] { get set }
}

class VisitorsListViewModel: VisitorsListViewModelProtocol {
    var visitorListTitles: [String]
    
    init(visitors: [Visitor]) {
        self.visitorListTitles = visitors.map { $0.name }
    }
}
