//
//  ViewController.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 12.09.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK: - Views
    
    private var mapView: MKMapView = MKMapView()
    private var bottomButton: UIButton = UIButton()
    
    // MARK: - Properties
    
    private var presenter: MapPresenter = {
        let service = MapService()
        return MapPresenter(service: service)
    }()
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        
        LocationManager.shared.requestLocation()
        setupMapView()
        setupBottomButton()
        
        presenter.getStations()
    }
}

// MARK: - Private Methods

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
        mapView.showsUserLocation = true
        mapView.delegate = self

        let userCoordinate = LocationManager.shared.manager.location?.coordinate
        let center = CLLocationCoordinate2D(
            latitude: userCoordinate?.latitude ?? 41.0082,
            longitude: userCoordinate?.longitude ?? 28.9784
        )
        mapView.region = .init(center: center, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
    }
    
    func setupBottomButton() {
        view.addSubview(bottomButton)
        
        let buttonHeight = 60.0
        
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            bottomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36.0)
        ])
        
        let attributedTitle = NSAttributedString(
            string: "List Trips",
            attributes: [
                .font : UIFont.systemFont(ofSize: 20.0, weight: .bold),
                .foregroundColor: UIColor.white
            ]
        )
        bottomButton.setAttributedTitle(attributedTitle, for: .normal)
        bottomButton.backgroundColor = .systemIndigo
        bottomButton.layer.cornerRadius = buttonHeight / 2
        
        let buttonTapGesture = UITapGestureRecognizer(target: self, action: #selector(didBottomButtonTapped))
        bottomButton.addGestureRecognizer(buttonTapGesture)
    }
}

// MARK: - MKMapViewDelegate

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
        
        guard let annotation = annotation as? StationAnnotation else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "AnnotationView",
            for: annotation
        )
        
        annotationView.image = UIImage(named: "Point")
        
        annotationView.canShowCallout = true
        let detailLabel = UILabel()
        detailLabel.text = "\(annotation.trip) Trips"
        annotationView.detailCalloutAccessoryView = detailLabel
        
        return annotationView
    }
    
    func mapView(
        _ mapView: MKMapView,
        didSelect view: MKAnnotationView
    ) {
        if view.annotation is StationAnnotation {
            view.updateImage(with: UIImage(named: "SelectedPoint"))
        }
    }
    
    func mapView(
        _ mapView: MKMapView,
        didDeselect view: MKAnnotationView
    ) {
        if view.annotation is StationAnnotation {
            view.updateImage(with: UIImage(named: "Point"))
        }
    }
}

// MARK: - Actions

private extension ViewController {
    
    @objc func didBottomButtonTapped() {
        guard let selectedStation = mapView.selectedAnnotations.first as? StationAnnotation else { return }
        presenter.didBottomButtonTapped(with: selectedStation.id)
    }
}

// MARK: - MapViewDelegate

extension ViewController: MapViewDelegate {
    
    func showMapPoints(annotations: [StationAnnotation]) {
        
        DispatchQueue.main.async { [weak self] in
            self?.mapView.addAnnotations(annotations)
        }
    }
    
    func showErrorDialog(message: String) {
        print("Error")
    }
    
    func navigateToTripList(station: Station) {
        let viewController = TripListViewController()
        let service = TripListService()
        let presenter = TripListPresenter(service: service, station: station)
        viewController.presenter = presenter
        navigationController?.pushViewController(viewController, animated: true)
    }
}
