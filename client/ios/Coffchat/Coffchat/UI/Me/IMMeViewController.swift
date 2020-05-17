//
//  IMMeViewController.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/24.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import UIKit

let kItemHeight = 50 // 设置项的高度

class IMMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tabView: UITableView!
    fileprivate var itemSource: [[(name: String, image: UIImage?)]] = [// [("", nil)],
        [(name: "设置", image: UIImage(named: "setting")),
         (name: "关于", image: UIImage(named: "about"))]]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我"

        tabView.register(UINib(nibName: "ImageTextTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTextTableViewCell")
        tabView.estimatedRowHeight = CGFloat(kItemHeight)
        tabView.backgroundColor = UIColor(red: 0xf5 / 255, green: 0xf6 / 255, blue: 0xf7 / 255, alpha: 1)
        tabView.tableFooterView = UIView()

        tabView.dataSource = self
        tabView.delegate = self
    }
}

// MARK: UITableViewDelegate

extension IMMeViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // 设置
        if indexPath.section == 0, indexPath.row == 0 {
            let viewController = IMSettingViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: UITableViewDataSource

extension IMMeViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ImageTextTableViewCell") as? ImageTextTableViewCell
        if cell == nil {
            cell = ImageTextTableViewCell()
        }

        let item = itemSource[indexPath.section][indexPath.row]
        cell!.setContent(title: item.name, image: item.image)
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemSource[section].count
    }
}
