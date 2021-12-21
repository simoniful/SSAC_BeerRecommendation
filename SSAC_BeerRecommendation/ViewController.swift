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
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
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



