//
//  NewsViewController.swift
//  SteamTest
//
//  Created by Александр Молчан on 27.05.23.
//

import UIKit
import SnapKit

final class NewsViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 30)
        label.textAlignment = .center
        label.text = "Новости"
        label.textColor = .black
        return label
    }()
    
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
    
    var currentId: Int?
    
    private lazy var emptyView = EmptyView()
    private var networkManager = NetworkManager()
    
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
        layoutElements()
        makeConstraints()
        registerCells()
    }
    
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
            self?.emptyViewSettings()
        }
    }

    
    private func layoutElements() {
        view.addSubview(tableView)
        view.addSubview(spinner)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
        headerView.addSubview(titleLabel)
        tableView.tableHeaderView = headerView
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
    
}

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
