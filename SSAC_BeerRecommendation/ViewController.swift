//
//  ViewController.swift
//  SSAC_BeerRecommendation
//
//  Created by Sang hun Lee on 2021/12/20.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let oveviewNibName = UINib(nibName: OverviewCell.identifier, bundle: nil)
        tableView.register(oveviewNibName, forCellReuseIdentifier: OverviewCell.identifier)
        let infoNibName = UINib(nibName: InfoCell.identifier, bundle: nil)
        tableView.register(infoNibName, forCellReuseIdentifier: InfoCell.identifier)
        return tableView
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
        button.backgroundColor = .systemMint
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.tintColor = .white
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    let stackContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    var infoData: Info?
    
    let model = [
        "Overview", "Information", "Food Pairing", "BrewerTips"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData { [self] Info in
            self.infoData = Info.first
            NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(notification:)), name: .myNotification, object: nil)
            view.addSubview(tableView)
            view.addSubview(stackContainerView)
            stackContainerView.addSubview(stackView)
            stackView.addArrangedSubview(refreshButton)
            stackView.addArrangedSubview(shareButton)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.snp.makeConstraints {
                $0.top.equalTo(view.snp.top)
                $0.leading.equalTo(view.snp.leading)
                $0.trailing.equalTo(view.snp.trailing)
                $0.bottom.equalTo(stackContainerView.snp.top)
            }
            stackContainerView.snp.makeConstraints {
                $0.trailing.equalTo(view.snp.trailing)
                $0.leading.equalTo(view.snp.leading)
                $0.bottom.equalTo(view.snp.bottom)
                $0.height.equalTo(70)
            }
            stackView.snp.makeConstraints {
                $0.top.equalTo(8)
                $0.trailing.equalTo(-8)
                $0.leading.equalTo(8)
                $0.bottom.equalTo(-8)
            }
            
            let header = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 3))
            let url = URL(string: Info.first!.imageURL ?? "")
            header.imageView.kf.setImage(with: url, placeholder: UIImage(named: "Image"))
            header.layer.zPosition = -2
            tableView.tableHeaderView = header
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("extensionBtnClicked"), object: nil)
    }
    
    @objc func receiveNotification(notification: NSNotification) {
        tableView.reloadData()
    }
    
    @objc func refreshButtonClicked () {
        fetchData { Info in
            self.infoData = Info.first
            let url = URL(string: Info.first!.imageURL ?? "")
            guard let headerImageView = self.tableView.tableHeaderView?.subviews.first?.subviews.first as? UIImageView else { return }
            headerImageView.kf.setImage(with: url, placeholder: UIImage(named: "Image"))
            self.tableView.reloadData()
        }
    }
    
    @objc func shareButtonClicked() {
        print("share")
    }
    
    func fetchData (completionHnadler: @escaping (_ list: [Info]) -> ())  {
        let number = Int.random(in: 1...325)
        let url = "https://api.punkapi.com/v2/beers/\(number)"
        print(url)
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let convertedData = try JSONDecoder().decode([Info].self, from: jsonData)
                    completionHnadler(convertedData)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension NSNotification.Name {
    static let myNotification = NSNotification.Name("extensionBtnClicked")
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let infoData = self.infoData else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as? OverviewCell else { return UITableViewCell()}
            cell.clipsToBounds = false
            cell.contentView.clipsToBounds = false
            cell.nameLabel.text = infoData.name
            cell.categoryLabel.text = infoData.tagline
            cell.overviewLabel.text = infoData.description
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoCell else { return UITableViewCell()}
            cell.titleLabel.text = "Information"
            cell.infoLabel.text = """
            ⬣ Alcohol by Volume: \(infoData.abv)
            ⬣ International Bittering Units: \(infoData.ibu == nil ? "unknown" : String(describing: infoData.ibu!))
            ⬣ Standard Reference Method: \(infoData.srm == nil ? "unknown" : String(describing: infoData.srm!))
            ⬣ European Brewery Convention: \(String(describing: infoData.ebc!))
            ⬣ pH: \(infoData.ph == nil ? "unknown" : String(describing: infoData.ph!))
            """
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoCell else { return UITableViewCell()}
            cell.titleLabel.text = "Food Pairing"
            cell.infoLabel.text = "\(infoData.foodPairing.joined(separator: "\n"))"
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoCell else { return UITableViewCell()}
            cell.titleLabel.text = "Brewers Tips"
            cell.infoLabel.text = "\(infoData.brewersTips))"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}



