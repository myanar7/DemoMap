//
//  AlertDialogViewController.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 17.09.2023.
//

import UIKit

final class AlertDialogViewController: UIViewController {
    
    // MARK: - Views
    
    private let boxView = UIView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = UIButton()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupStackView()
    }
}

// MARK: - Private Methods

private extension AlertDialogViewController {
    
    func setupUI() {
        
        // Background View Configuration
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        view.addSubview(boxView)
        boxView.backgroundColor = .white
        
        // Background View Constraints
        boxView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            boxView.widthAnchor.constraint(equalToConstant: view.frame.width - 64.0)
        ])
    }
    
    func setupStackView() {
        
        boxView.addSubview(stackView)
        
        // StackView Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 16.0),
            stackView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -16.0),
            stackView.rightAnchor.constraint(equalTo: boxView.rightAnchor, constant: -8.0),
            stackView.leftAnchor.constraint(equalTo: boxView.leftAnchor, constant: 8.0)
        ])
        
        // StackView Configuration
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        // Alert Title Label Configuration
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        titleLabel.text = "The trip you selected is full."
        
        // Alert Subtitle Label Configuration
        stackView.addArrangedSubview(subtitleLabel)
        subtitleLabel.font = .systemFont(ofSize: 16.0)
        subtitleLabel.text = "Please select another one."
        
        // Alert Action Button Configuration
        stackView.addArrangedSubview(actionButton)
        actionButton.setTitle("Select a Trip", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .systemIndigo
        
        // Alert Action Button Constraints
        let actionButtonHeight = 48.0
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48.0),
            actionButton.heightAnchor.constraint(equalToConstant: actionButtonHeight),
            actionButton.centerXAnchor.constraint(equalTo: boxView.centerXAnchor)
        ])
        actionButton.layer.cornerRadius = actionButtonHeight / 2
        
        // Alert Action Button Action
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        actionButton.addGestureRecognizer(dismissTapGesture)
        
    }
}

// MARK: - Actions

@objc private extension AlertDialogViewController {
    
    func dismissAlert() {
        dismiss(animated: true)
    }
}
