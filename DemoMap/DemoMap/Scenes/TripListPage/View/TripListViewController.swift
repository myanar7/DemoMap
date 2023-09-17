//
//  TripListViewController.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 16.09.2023.
//

import UIKit

final class TripListViewController: UIViewController {
    
    // MARK: - Views
    
    private var titleLabel: UILabel = UILabel()
    private var tableView: UITableView = UITableView()
    
    // MARK: - Properties
    
    private let titleText = "Trips"
    
    var station: Station?
    var presenter: TripListPresenter!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        presenter.delegate = self
        setupUI()
    }
}

// MARK: - Private Methods

private extension TripListViewController {
    
    func setupUI() {
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setupTitleLabel()
        setupTableView()
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
        ])

        titleLabel.text = titleText
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        titleLabel.textColor = .black
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0)
        ])

        tableView.dataSource = self
        
        tableView.register(TripListTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

// MARK: - TableViewDataSource

extension TripListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.station.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TripListTableViewCell else { return .init() }
        
        cell.titleText = presenter.station.trips[indexPath.row].busName
        cell.timeText = presenter.station.trips[indexPath.row].time
        cell.buttonTapped = { [weak self] in
            guard let self else { return }
            self.presenter.bookTrip(
                for: self.presenter.station.id,
                by: self.presenter.station.trips[indexPath.row].id
            )
        }
        cell.prepareForReuse()
        return cell
    }
}

// MARK: - TripListDelegate

extension TripListViewController: TripListDelegate {
    
    /// Define the action which will occur when the trip is booked succesfully
    func didTripBooked(stationId: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
            guard let mapViewController = self.navigationController?.visibleViewController as? MapViewController else { return }
            mapViewController.presenter.updateBookedStations(with: stationId)
        }
    }
    
    /// Define the action which will occur when the trip booking is failed
    func didErrorBooking() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertVC = AlertDialogViewController()
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.isModalInPresentation = true
            self.present(alertVC, animated: false)
        }
    }
}
