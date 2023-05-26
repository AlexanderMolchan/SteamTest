//
//  EmptyView.swift
//  SteamTest
//
//  Created by Александр Молчан on 27.05.23.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    private let imageView = UIImageView()
    private let topLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        addSubview(imageView)
        imageView.image = UIImage(systemName: "xmark.icloud")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        addSubview(topLabel)
        topLabel.font = UIFont(name: "Marker Felt Thin", size: 30)
        topLabel.textColor = .lightGray
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        topLabel.text = "Ничего не найдено"
        topLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(imageView.snp.top).inset(-20)
        }
    }

}
