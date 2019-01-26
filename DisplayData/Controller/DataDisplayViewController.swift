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
    var viewModel: DataFetchViewModel!
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        dataTable.refreshControl = refreshControl
        viewModel = DataFetchViewModel(min: 2008, max: 2018, networkManager: AppProvider.networkManager)
        fetchData()
    }
    @objc func fetchData() {
        self.dataTable.refreshControl?.beginRefreshing()
        viewModel.resetData()
        self.dataTable.reloadData()
        viewModel.fetchData(completionHandler: { (errorMessage) in
            if let message = errorMessage {
                //display an alert
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.titleLabel.text = "Displaying the amount the of data sent over Singapore’s mobile networks from 2008 to 2018."
                self.dataTable.reloadData()
            }
            DispatchQueue.main.async {
                self.dataTable.refreshControl?.endRefreshing()
            }
        })
    }
    @IBAction func clearCachedData(_ sender: Any) {
        DataBaseManager.deleteRecords()
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
            viewModel.fetchData { _ in
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
