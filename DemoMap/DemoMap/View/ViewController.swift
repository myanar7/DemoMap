//
//  ViewController.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 12.09.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    private var mapView: MKMapView = MKMapView()
    private var presenter: MapPresenter = {
        let service = MapService()
        return MapPresenter(service: service)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        
        LocationManager.shared.requestLocation()
        setupMapView()
        
        presenter.getStations()
    }
}

private extension ViewController {
    
    func setupMapView() {
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
        
        /*
        let overlayPath = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
        let overlay = MKTileOverlay(urlTemplate: overlayPath)
        overlay.canReplaceMapContent = true
        self.mapView.addOverlay(overlay)
        */
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "AnnotationView")
        
        mapView.delegate = self

        let center = CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784)
        mapView.region = .init(center: center, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
        
        mapView.showsUserLocation = true
        
        
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer(overlay: overlay)
        }
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        
        guard annotation is StationAnnotation else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "AnnotationView",
            for: annotation
        )

        annotationView.image = UIImage(named: "Point")
        
        return annotationView
    }
}

extension ViewController: MapViewDelegate {
    
    func showMapPoints(annotations: [StationAnnotation]) {
        
        mapView.addAnnotations(annotations)
    }
    
    func showErrorDialog(message: String) {
        print("Error")
    }
}
