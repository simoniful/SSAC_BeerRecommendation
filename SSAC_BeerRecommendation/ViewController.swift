//
//  ViewController.swift
//  SSAC_BeerRecommendation
//
//  Created by Sang hun Lee on 2021/12/20.
//

import UIKit




class ViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let oveviewNibName = UINib(nibName: OverviewCell.identifier, bundle: nil)
        tableView.register(oveviewNibName, forCellReuseIdentifier: OverviewCell.identifier)
        return tableView
    }()
    
    let model = [
        "NewYork", "London", "HongKong", "Seattle", "NewYork", "London", "HongKong", "Seattle", "NewYork", "London", "HongKong", "Seattle", "NewYork", "London", "HongKong", "Seattle", "NewYork", "London", "HongKong", "Seattle", "NewYork", "London", "HongKong", "Seattle", "NewYork", "London", "HongKong", "Seattle", "NewYork", "London", "HongKong", "Seattle"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(notification:)), name: .myNotification, object: nil)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        let header = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 4))
        header.imageView.image = UIImage(named: "Image")
        header.layer.zPosition = -2
        tableView.tableHeaderView = header
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("extensionBtnClicked"), object: nil)
    }
    
    @objc func receiveNotification(notification: NSNotification) {
        tableView.reloadData()
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
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as? OverviewCell else { return UITableViewCell()}
            cell.clipsToBounds = false
            cell.contentView.clipsToBounds = false
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        default:
            return 44
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}



