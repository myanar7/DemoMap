//
//  MapPresenter.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 13.09.2023.
//

import Foundation
import MapKit

final class StationAnnotation: NSObject, MKAnnotation {
    var id: Int
    var coordinate: CLLocationCoordinate2D
    
    init(id: Int, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.coordinate = coordinate
    }
}

protocol MapViewDelegate: AnyObject {
    func showMapPoints(annotations: [StationAnnotation])
    func showErrorDialog(message: String)
}

final class MapPresenter {
    
    weak var delegate: MapViewDelegate?
    
    private let service: MapService
    
    init(service: MapService) {
        self.service = service
    }
    
    func getStations() {
        service.getStations { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                
                let mapPoints: [StationAnnotation] = response.compactMap { station in
                    
                    guard let (coordinateX, coordinateY) = station.centerCoordinates.coordinate2D() else { return nil}
                    let coordinate = CLLocationCoordinate2D(latitude: coordinateX, longitude: coordinateY)
                    return StationAnnotation(id: station.id, coordinate: coordinate)
                }
                
                self.delegate?.showMapPoints(annotations: mapPoints)
                
            case let .failure(error):
                
                self.delegate?.showErrorDialog(message: error.localizedDescription)
                
            }
            
        }
    }
    
}
