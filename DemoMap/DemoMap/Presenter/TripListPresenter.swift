//
//  TripListPresenter.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 17.09.2023.
//

import Foundation

protocol TripListDelegate: AnyObject {
    func didTripBooked(stationId: Int)
    func didErrorBooking()
}

final class TripListPresenter {
    
    // MARK: - Properties
    
    weak var delegate: TripListDelegate?
    
    private let service: TripListServiceProtocol
    
    let station: Station
    
    init(service: TripListService, station: Station) {
        self.service = service
        self.station = station
    }
    
    func bookTrip(for stationId: Int, by tripId: Int) {
        
        service.bookTrip(stationId: stationId, tripId: tripId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                
                self.delegate?.didTripBooked(stationId: stationId)
                
            case .failure(_):
                
                self.delegate?.didErrorBooking()
                
            }
        }
    }
}
