//
//  MapService.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 13.09.2023.
//

import Foundation



final class MapService: Service {
    
    private enum Endpoints: String {
        case getStation = "https://demo.voltlines.com/case-study/6/stations"
        case bookTrip = "https://demo.voltlines.com/case-study/6/stations/%d/trips/%d"
    }
    
    private enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    private let session = URLSession.shared
    
    func getStations(completion: @escaping (Result<[Station],Error>) -> Void) {
        request(endpoint: Endpoints.getStation.rawValue,
                method: HTTPMethod.GET.rawValue,
                completion: completion)
    }
    
    func bookTrip() {
        
    }
}

