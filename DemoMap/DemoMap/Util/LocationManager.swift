//
//  LocationManager.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 13.09.2023.
//

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static var shared: LocationManager = LocationManager()
    
    private(set) var manager: CLLocationManager = CLLocationManager()
    
    func requestLocation() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.manager.requestWhenInUseAuthorization()
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.distanceFilter=kCLDistanceFilterNone
            self.manager.startUpdatingLocation()
        }
    }
}
