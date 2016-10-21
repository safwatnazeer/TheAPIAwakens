//
//  APIClient.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 16/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

public let NetworkingErrorDomain = "com.safwat.TheAPIAwaken.NetworkingError"
public let MissingHTTPResponseError = 10

typealias JSONDictionary = [String:AnyObject]
typealias Handler = () -> Void




struct DownloadRequest{
    
    let urls : [String]
    let nextPageJSONKeyword: String?
    let resultExtractJSONKeyword: String
    
}

class APIClient {
    
    private var objectData : [JSONDictionary]
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    init()
    {
        self.objectData = [JSONDictionary]()
    }

    func fetchFullData(objectType : ObjectType, completionHandler: @escaping ([JSONDictionary]) -> Void) {
         //let config = URLSessionConfiguration.default
        //config.timeoutIntervalForRequest = 5
         let url = "http://swapi.co/api/\(objectType.rawValue)/"
         fetchDataWithMultiPages(urlString: url, completionHandler: completionHandler)
    }

    
    
    func fetchDataWithMultiURLS<T>(request: DownloadRequest,  completionHandler: @escaping ([T]) -> Void ){
        
        var tempData = [T]()
        var remainingDownloadTasks = request.urls.count
        
        for url in request.urls {
            downloadJSON(urlString: url ) {
                jsonData in
                remainingDownloadTasks -= 1
                if let result = jsonData[request.resultExtractJSONKeyword] as? T
                {
                    tempData.append(result)
                    if remainingDownloadTasks == 0 { completionHandler(tempData)}
                }
            }
        }
    
    }
   
    func fetchDataWithMultiPages(urlString: String, completionHandler: @escaping ([JSONDictionary]) -> Void)
    {
        
        downloadJSON(urlString: urlString) {
            jsonData in
            
            if let nextPage = jsonData["next"] as? String {
                print(nextPage)
                if let results = jsonData["results"] as? [JSONDictionary] {
                    for result in results {
                        self.objectData.append(result)
                    }
                }
                self.fetchDataWithMultiPages(urlString: nextPage, completionHandler: completionHandler)
            }
            else {
                print("That was the last one ---- ")
                completionHandler(self.objectData)
            }
        }
    }
    
    func downloadJSON(urlString: String, completionHandler: @escaping (JSONDictionary) -> Void) {
        let url = URL(string: urlString)
        let task = session.dataTask(with: url!) { data, response, error in
            // TODO: implement error handeling for JSON Downaloder
            
            guard let response = response as? HTTPURLResponse else {
                print("Missing Http Response .. ")
                return
            }
            print ("Response Sttus code-->  \(response.statusCode)")
            print ("error -->  \(error?.localizedDescription)")
            if let data = data {
                if let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                {
                    completionHandler(jsonData)
                } else {
                    // TODO: Error can't convert data to JSON
                    print ("Error can't convert data to JSON")
                }
            }
      }
        task.resume()
    }
    
    }
/*
 let task = session.dataTask(with: urlRequest) {
 data, response, error in
 
 guard let response = response as? HTTPURLResponse else {
 
 let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
 ]
 let error = NSError(domain: NetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
 return
 }
 print ("Response Sttus code-->  \(response.statusCode)")
 print ("error -->  \(error?.localizedDescription)")
 
 if let data = data { print ("data -->  \(data)")
 
  }
 */
