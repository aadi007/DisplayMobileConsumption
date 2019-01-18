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
    var records = [Record]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        AppProvider.networkManager.request(NetworkRouter.getData(resourceId: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 20, query: "2008")) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    do {
                        print(try moyaResponse.mapJSON())
                    } catch {
                        print(moyaResponse.data)
                    }
                } else {
                    print(statusCode)
                }
            case let .failure(error):
                print("error \(error.errorDescription ?? "")")
            }
        }
    }
}
extension DataDisplayViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DataDisplayTableViewCell", for: indexPath) as? DataDisplayTableViewCell {
            cell.dataLabel.text = indexPath.row.description
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
