//
//  GameCell.swift
//  SteamTest
//
//  Created by Александр Молчан on 26.05.23.
//

import UIKit
import SnapKit

final class GameCell: UITableViewCell {
    static let id = String(describing: GameCell.self)
    private var currentGame: GameModel
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    init(gameModel: GameModel) {
        self.currentGame = gameModel
        super.init(style: .default, reuseIdentifier: GameCell.id)
        cellConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellConfiguration() {
        layoutElements()
        makeConstraints()
        dataSettings()
    }
    
    private func layoutElements() {
        contentView.addSubview(nameLabel)
    }
    
    private func makeConstraints() {
        let labelInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(labelInsets)
            make.height.equalTo(30)
        }
    }
    
    private func dataSettings() {
        self.nameLabel.text = currentGame.name
    }
    
}
