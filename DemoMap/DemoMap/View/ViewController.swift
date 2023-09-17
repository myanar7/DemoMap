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
    
    var presenter: MapPresenter = {
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
        
        annotationView.image = annotation.isBooked ? UIImage(named: "Completed") : UIImage(named: "Point")
        
        annotationView.isEnabled = !annotation.isBooked
        annotationView.canShowCallout = !annotation.isBooked
        let detailLabel = UILabel()
        detailLabel.text = "\(annotation.trip) Trips"
        annotationView.detailCalloutAccessoryView = detailLabel
        
        return annotationView
    }
    
    func mapView(
        _ mapView: MKMapView,
        didSelect view: MKAnnotationView
    ) {
        //TODO: Add a condition to detect whether station is booked or not
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
        mapView.deselectAnnotation(selectedStation, animated: true)
        presenter.didBottomButtonTapped(with: selectedStation.id)
    }
}

// MARK: - MapViewDelegate

extension ViewController: MapViewDelegate {
    
    func updateBookedStation(with stationAnnotation: StationAnnotation) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let annotation = self.mapView.annotations.first(where: { stationAnnotation.isEqual($0) }) else { return }
            self.mapView.removeAnnotation(annotation)
            self.mapView.addAnnotation(stationAnnotation)
        }
    }
    
    func showMapPoints(annotations: [StationAnnotation]) {
        
        DispatchQueue.main.async { [weak self] in
            self?.mapView.addAnnotations(annotations)
        }
    }
    
    func showErrorDialog(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                fatalError()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToTripList(station: Station) {
        let viewController = TripListViewController()
        let service = TripListService()
        let presenter = TripListPresenter(service: service, station: station)
        viewController.presenter = presenter
        navigationController?.pushViewController(viewController, animated: true)
    }
}
