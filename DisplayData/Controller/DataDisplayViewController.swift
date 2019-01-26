//
//  DataDisplayViewController.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 1/18/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class DataDisplayViewController: UIViewController {
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    let viewModel = DataFetchViewModel(min: 2008, max: 2018, networkManager: AppProvider.networkManager)
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData {
            self.titleLabel.text = "Displaying the amount the of data sent over Singapore’s mobile networks from 2008 to 2018."
            self.dataTable.reloadData()
        }
    }
}
extension DataDisplayViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.records.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.records.count - 1 {
            //make another call
            viewModel.fetchData {
                self.dataTable.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DataDisplayTableViewCell", for: indexPath) as? DataDisplayTableViewCell {
            cell.configureCell(record: viewModel.records[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
