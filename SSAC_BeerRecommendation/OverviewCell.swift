//
//  OverviewCell.swift
//  SSAC_BeerRecommendation
//
//  Created by Sang hun Lee on 2021/12/20.
//

import UIKit
import SnapKit


class OverviewCell: UITableViewCell {
    static let identifier = "OverviewCell"
    var isOpened = false

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "제품명"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "제품종류"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 3
        label.text = "제품내용"
        return label
    }()
    
    let extensionButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(extensionButtonClicked), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let overviewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubview(overviewContainer)
        overviewContainer.snp.makeConstraints {
            $0.top.equalTo(-65)
            $0.bottom.equalTo(-20)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        overviewContainer.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(extensionButton)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-10)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func extensionButtonClicked(_ sender: UIButton) {
        isOpened = !isOpened
        if isOpened == false {
            overviewLabel.numberOfLines = 3
        } else if isOpened == true {
            overviewLabel.numberOfLines = 0
        }
        NotificationCenter.default.post(name: NSNotification.Name("extensionBtnClicked"), object: nil, userInfo: ["isOpened": isOpened, "sender": sender])
    }
}

