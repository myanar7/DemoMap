//
//  TripListService.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 17.09.2023.
//

import Foundation

protocol TripListServiceProtocol {
    func bookTrip(stationId: Int, tripId: Int, completion: @escaping (Result<Trip,URLError>) -> Void)
}

final class TripListService: Service, TripListServiceProtocol {
    
    private enum Endpoints: String {
        case bookTrip = "https://demo.voltlines.com/case-study/6/stations/%ld/trips/%ld"
    }
    
    func bookTrip(stationId: Int, tripId: Int, completion: @escaping (Result<Trip,URLError>) -> Void) {
        request(
            endpoint: String(format: Endpoints.bookTrip.rawValue, stationId, tripId),
            method: HTTPMethod.POST.rawValue,
            completion: completion
        )
    }
}
