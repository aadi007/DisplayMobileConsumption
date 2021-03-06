//
//  DataFetchViewModel.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 1/18/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper

class DataFetchViewModel {
    var records = [YearRecord]()
    private let pageLimit = 4
    private let resourceId = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
    private var minLimit = 2008
    private var maxLimit = 2018
    private var queryArray = [String]()
    private var queryIndex = 0
    private var networkResource: NetworkProvider<NetworkRouter> = AppProvider.networkManager
    init(min: Int, max: Int, networkManager: NetworkProvider<NetworkRouter>) {
        self.minLimit = min
        self.maxLimit = max
        self.networkResource = networkManager
        fillQueryDetails()
    }
    func fillQueryDetails() {
        let diff = maxLimit - minLimit
        for i in 0..<diff + 1 {
            queryArray.append((minLimit + i).description)
        }
    }
    func getYearsQueryArray() -> [String] {
        return queryArray
    }
    func resetData() {
        records.removeAll()
        queryIndex = 0
    }
    func fetchData(completionHandler: @escaping ((_ errorMessage: String?) -> Void)) {
        queryIndex += 1
        if queryIndex > queryArray.count {
            //End of list
            return
        }
        let currentYear = queryArray[queryIndex - 1]
        if let yearRecord = DataBaseManager.getRecordFor(year: currentYear) {
            self.records.append(yearRecord)
            completionHandler(nil)
        } else {
            networkResource.request(NetworkRouter.getData(resourceId: resourceId, limit: pageLimit, query: currentYear)) { result in
                switch result {
                case let .success(moyaResponse):
                    let statusCode = moyaResponse.statusCode
                    if statusCode == 200 {
                        do {
                            if let data = try moyaResponse.mapJSON() as? [String: Any] {
                                if let apiResponse = Mapper<DataFetchAPIResponse>().map(JSONObject: data),
                                    let apiRecordsFetched = apiResponse.records  {
                                    //check for the request keys
                                    let urlComponent = URLComponents(url: (moyaResponse.request?.url!)!, resolvingAgainstBaseURL: false)
                                    let record = YearRecord()
                                    record.config(quaters: apiRecordsFetched, year: urlComponent?.queryItems?.filter({ $0.name == "q" }).first?.value ?? "")
                                    self.records.append(record)
                                    //store the data in persistent storage
                                    DataBaseManager.storeYearRecord(yearRecord: record)
                                }
                                print(data)
                                completionHandler(nil)
                            }
                        } catch {
                            print(moyaResponse.data)
                            completionHandler("Failed to parse the json response")
                        }
                    } else {
                        print(statusCode)
                        completionHandler("Failed with statusCode \(statusCode)")
                    }
                case let .failure(error):
                    print("error \(error.errorDescription ?? "")")
                    completionHandler(error.errorDescription)
                }
            }
        }
    }
}
