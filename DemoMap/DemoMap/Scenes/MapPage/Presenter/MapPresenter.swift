//
//  MapPresenter.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 13.09.2023.
//

import Foundation

protocol MapViewDelegate: AnyObject {
    func updateBookedStation(with: StationAnnotation)
    func showMapPoints(annotations: [StationAnnotation])
    func showErrorDialog(message: String)
    func navigateToTripList(station: Station)
}

final class MapPresenter {
    
    weak var delegate: MapViewDelegate?
    
    private let service: MapService
    
    private var stations: [Station] = []
    private var bookedStations: [Station] = []
    
    init(service: MapService) {
        self.service = service
    }
    
    func getStations() {
        service.getStations { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.stations = response
                
                let mapPoints: [StationAnnotation] = response.compactMap { station in
                    
                    guard let (coordinateX, coordinateY) = station.centerCoordinates.coordinate2D() else { return nil}
                    return StationAnnotation(
                        id: station.id,
                        trip: station.tripsCount,
                        latitude: coordinateX,
                        longtitude: coordinateY
                    )
                }
                self.delegate?.showMapPoints(annotations: mapPoints)
                
            case let .failure(error):
                
                self.delegate?.showErrorDialog(message: error.localizedDescription)
            }
        }
    }
    
    func didBottomButtonTapped(with id: Int) {
        guard let station = stations.first(where: { $0.id == id }) else { return }
        delegate?.navigateToTripList(station: station)
    }
    
    func updateBookedStations(with stationId: Int) {
        guard let station = stations.first(where: { $0.id == stationId }) else { return }
        guard let (coordinateX, coordinateY) = station.centerCoordinates.coordinate2D() else { return }
        let bookedStationAnnotation = StationAnnotation(
            id: station.id,
            trip: station.tripsCount,
            isBooked: true,
            latitude: coordinateX,
            longtitude: coordinateY
        )
        self.delegate?.updateBookedStation(with: bookedStationAnnotation)
    }
}
