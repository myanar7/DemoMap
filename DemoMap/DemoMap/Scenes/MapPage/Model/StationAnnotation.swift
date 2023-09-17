//
//  StationAnnotation.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 17.09.2023.
//

import MapKit

final class StationAnnotation: NSObject, MKAnnotation {
    var id: Int
    var trip: Int
    var isBooked: Bool
    var latitude: CGFloat
    var longtitude: CGFloat
    
    var coordinate: CLLocationCoordinate2D
    
    init(id: Int, trip: Int, isBooked: Bool = false, latitude: CGFloat, longtitude: CGFloat) {
        self.id = id
        self.trip = trip
        self.isBooked = isBooked
        self.latitude = latitude
        self.longtitude = longtitude
        
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? StationAnnotation else { return false}
        return object.id == id
    }
}
