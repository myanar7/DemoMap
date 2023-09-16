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
    
    var station: Station?
    
    var presenter: TripListPresenter!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        presenter.delegate = self
        setupUI()
    }
}

// MARK: - TripListDelegate

extension TripListViewController: TripListDelegate {
    
    func didTripBooked(stationId: Int) {
        print("Booked")
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            
            
            //TODO: coordinator kullan
        }
    }
    
    func didErrorBooking() {
        print("Error")
    }
}

// MARK: - Private Methods

private extension TripListViewController {
    
    func setupUI() {
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
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

        titleLabel.text = "Trips"
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


final class TripListTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let bookButton = UIButton()
    
    private let buttonText = "Book"
    
    var titleText: String?
    var timeText: String?
    var buttonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    override func prepareForReuse() {
        titleLabel.text = titleText
        timeLabel.text = timeText
    }
    
    private func setupCell() {
        
        selectionStyle = .none
        accessoryType = .none
        
        contentView.backgroundColor = UIColor.white

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        bookButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(bookButton)

        //Leftmost
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
        
        // Rightmost
        NSLayoutConstraint.activate([
            bookButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bookButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            bookButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
        
        //LeftOfBookButton
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor, constant: 8.0),
            timeLabel.trailingAnchor.constraint(equalTo: bookButton.leadingAnchor, constant: -8.0),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
        
        bookButton.layer.cornerRadius = bookButton.frame.height / 2
        bookButton.setTitle(buttonText, for: .normal)
        bookButton.backgroundColor = .systemIndigo
        
        let cellButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(didBookButtonTapped))
        bookButton.addGestureRecognizer(cellButtonTapGesture)
    }
    
    @objc private func didBookButtonTapped() {
        buttonTapped?()
    }
}
