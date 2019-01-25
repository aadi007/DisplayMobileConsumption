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
    init(min: Int, max: Int) {
        self.minLimit = min
        self.maxLimit = max
        fillQueryDetails()
    }
    func fillQueryDetails() {
        let diff = maxLimit - minLimit
        for i in 0..<diff + 1 {
            queryArray.append((minLimit + i).description)
        }
        print(queryArray)
    }
    func fetchData(completionHandler: @escaping (() -> Void)) {
        queryIndex += 1
        if queryIndex > queryArray.count {
            print("End of data")
            return
        }
        AppProvider.networkManager.request(NetworkRouter.getData(resourceId: resourceId, limit: pageLimit, query: queryArray[queryIndex - 1])) { result in
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
                                let record = YearRecord(quaters: apiRecordsFetched, year: urlComponent?.queryItems?.filter({ $0.name == "q" }).first?.value ?? "")
                                self.records.append(record)
                            }
                            print(data)
                        }
                    } catch {
                        print(moyaResponse.data)
                        completionHandler()
                    }
                } else {
                    print(statusCode)
                }
                completionHandler()
            case let .failure(error):
                print("error \(error.errorDescription ?? "")")
                completionHandler()
            }
        }
    }
}
