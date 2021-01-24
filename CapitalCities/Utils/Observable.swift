//
//  Observable.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 24/01/2021.
//

import Foundation

class Observable<T> {
    typealias Listner = ((T) -> ())
    var listner: Listner?
    
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.listner?(self.value)
            }
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bind(listner: Listner?) {
        self.listner = listner
        listner?(value)
    }
}
