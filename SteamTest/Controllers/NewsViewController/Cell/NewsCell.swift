//
//  NewsCell.swift
//  SteamTest
//
//  Created by Александр Молчан on 27.05.23.
//

import UIKit
import SnapKit
import SwiftSoup

final class NewsCell: UITableViewCell {
    static let id = String(describing: NewsCell.self)
    let currentNews: NewsModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    init(news: NewsModel) {
        self.currentNews = news
        super.init(style: .default, reuseIdentifier: NewsCell.id)
        cellConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellConfiguration() {
        layoutElements()
        makeConstraints()
        setupData()
    }
    
    private func layoutElements() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(newsLabel)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        newsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func filterTagsFrom(text: String) -> String {
        return text.replacingOccurrences(of: "\\[.*\\]", with: "", options: String.CompareOptions.regularExpression)
    }
    
    private func setupData() {
        titleLabel.text = currentNews.title
        do {
            let doc: Document = try SwiftSoup.parse(currentNews.contents)
            let parseNews = try doc.text()
            newsLabel.text = parseNews
        } catch {
            print("Error")
        }
    }
    
}

extension String {
    func removingUrls() -> String {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return self }
        return detector.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "")
    }
}
