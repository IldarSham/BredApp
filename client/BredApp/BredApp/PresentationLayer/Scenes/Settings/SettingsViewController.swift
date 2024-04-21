//
//  SettingsViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.03.2024.
//

import UIKit
import Combine

class SettingsViewController: NiblessViewController {
    
    // MARK: - Properties
    
    let viewModel: SettingsViewModel
    
    // State
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
        return tableView
    }()

    // MARK: - Initialization
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        constructHierarchy()
        activateConstraints()
        observeViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationItem() {
        self.navigationItem.title = L.SettingsScreen.navigationItemTitle.localized
    }
    
    private func constructHierarchy() {
        self.view.addSubview(tableView)
    }
    
    private func activateConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func observeViewModel() {
        viewModel.errorMessages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                guard let self = self else { return }
                self.presentAlert(title: alert.title, message: alert.message)
            }
            .store(in: &subscriptions)
    }
}

protocol SettingsViewControllerFactory {

    func makeSettingsViewController(delegate: SettingsFlowDelegate) -> SettingsViewController
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as! SettingsCell
        cell.configure(with: viewModel.getCellModel(for: indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(index: indexPath.row)
    }
}
