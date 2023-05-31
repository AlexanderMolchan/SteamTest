//
//  NewsViewController.swift
//  SteamTest
//
//  Created by Александр Молчан on 27.05.23.
//

import UIKit
import SnapKit

final class NewsViewController: UIViewController {
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
        
    private lazy var emptyView = EmptyView()
    private var networkManager = NetworkManager()
    var currentId: Int?
    
    private var newsArray = [NewsModel]() {
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
        self.view.backgroundColor = .white
        navigationControllerSettings(title: "Новости")
        layoutElements()
        makeConstraints()
        registerCells()
        refreshControllConfiguration()
    }
    
    // MARK: -
    // MARK: - UI Configuration
    
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
        guard let currentId else { return emptyViewSettings() }
        spinner.startAnimating()
        networkManager.getNewsForAppWith(id: currentId) { [weak self] result in
            guard  let self else { return }
            self.newsArray = result.appnews.newsitems
            self.emptyViewSettings()
            self.spinner.stopAnimating()
        } failure: { [weak self] error in
            self?.spinner.stopAnimating()
            self?.showAlert(title: "Network Error!", message: "Please, try again later.")
            self?.emptyViewSettings()
        }
    }
    
    private func registerCells() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.id)
    }
    
    private func emptyViewSettings() {
        if newsArray.isEmpty {
            view.addSubview(emptyView)
            view.bringSubviewToFront(emptyView)
            emptyView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            emptyView.removeFromSuperview()
        }
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

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NewsCell(news: newsArray[indexPath.row])
    }
    
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
