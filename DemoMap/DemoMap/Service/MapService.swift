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
    }
    
    func getStations(completion: @escaping (Result<[Station],URLError>) -> Void) {
        request(
            endpoint: Endpoints.getStation.rawValue,
            method: HTTPMethod.GET.rawValue,
            completion: completion
        )
    }
}

