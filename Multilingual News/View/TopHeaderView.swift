//
//  TopHeaderView.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit

class TopHeaderView: UIView {

    // MARK: Properties

    var topHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.8

        imageView.layer.masksToBounds = true
        imageView.layer.shouldRasterize = true
        imageView.layer.cornerRadius = 30

        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor

        imageView.layer.shadowColor = UIColor.white.withAlphaComponent(0.7).cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 0.5

        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = Constants.customUIColor.oceanBlue
        label.numberOfLines = 0
        return label
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .systemGray4
        label.numberOfLines = 1
        return label
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers

    private func configureUI() {
        [
            topHeaderImageView,
            titleLabel,
            dateLabel
        ].forEach {
            addSubview($0)
        }

        topHeaderImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.6)

            make.top.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.2)

            make.top.equalTo(topHeaderImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }

        dateLabel.snp.makeConstraints { (make) -> Void in

            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
