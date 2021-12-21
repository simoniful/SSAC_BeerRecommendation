//
//  InfoCell.swift
//  SSAC_BeerRecommendation
//
//  Created by Sang hun Lee on 2021/12/20.
//

import UIKit

class InfoCell: UITableViewCell {
    static let identifier = "InfoCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Infomation"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Specific"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(infoLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-20)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
