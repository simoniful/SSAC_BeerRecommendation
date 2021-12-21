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
    

    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
