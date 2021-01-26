//
//  Reachability.swift
//  CitiesRepository
//
//  Created by Michal Jackowski on 26/01/2021.
//

import Foundation
import Network

class Reachability {
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var unreachable: Bool { status == .unsatisfied}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
