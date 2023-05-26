//
//  MainViewController.swift
//  SteamTest
//
//  Created by Александр Молчан on 26.05.23.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .systemCyan
        return spinner
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .systemCyan
        return refresh
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self
        return searchController
    }()
    
    private lazy var emptyView = EmptyView()
    private var networkManager = NetworkManager()
    
    private var gameArray = [GameModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var filteredArray = [GameModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfigurate()
        getData()
    }
    
    private func controllerConfigurate() {
        navigationControllerSettings()
        refreshControllConfiguration()
        registerCells()
        layoutElements()
        makeConstraints()
        searchSettings()
    }
    
    // MARK: -
    // MARK: - UI Configuration
    
    private func navigationControllerSettings() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Список приложений"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemCyan, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 35) as Any]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemCyan, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 20) as Any]
    }
    
    private func layoutElements() {
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: -
    // MARK: - Logic
    
    private func getData() {
        spinner.startAnimating()
        networkManager.getGamesListData { [weak self] result in
            guard let self else { return }
            self.gameArray = result.applist.apps.filter({ $0.name != "" }).sorted(by: { $0.name < $1.name })
            self.filteredArray = self.gameArray
            self.searchController.searchBar.searchTextField.text?.removeAll()
            self.emptyViewSettings(array: self.gameArray)
            self.spinner.stopAnimating()
        } failure: { [weak self] error in
            guard let self else { return }
            self.showAlert(title: "Network Error!", message: "Please, try again later.")
            self.spinner.stopAnimating()
            print(error)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    private func emptyViewSettings(array: [GameModel]) {
        if array.isEmpty {
            view.addSubview(emptyView)
            emptyView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            emptyView.removeFromSuperview()
        }
    }
    
    private func registerCells() {
        tableView.register(GameCell.self, forCellReuseIdentifier: GameCell.id)
    }
    
    private func refreshControllConfiguration() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
    @objc private func refreshAction() {
        getData()
        refreshControl.endRefreshing()
    }
    
}

// MARK: -
// MARK: - TableView Extension

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        GameCell(gameModel: filteredArray[indexPath.row])
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsVc = NewsViewController()
        newsVc.currentId = filteredArray[indexPath.row].appid
        present(newsVc, animated: true)
    }
}

// MARK: -
// MARK: - Search Settings

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate, UITextFieldDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              !text.isEmpty else {
            filteredArray = gameArray
            return
        }
        filteredArray = gameArray.filter({ $0.name.lowercased().contains(text.lowercased()) })
        emptyViewSettings(array: filteredArray)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        emptyViewSettings(array: gameArray)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        emptyViewSettings(array: gameArray)
        return true
    }
    
    private func searchSettings() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск по имени"
        self.navigationItem.searchController = searchController
    }
    
}
