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



// download request struct for request with multiple URLs
struct DownloadRequest{
    let urls : [String]
    let nextPageJSONKeyword: String?
    let resultExtractJSONKeyword: String
    
}


class APIClient {
    
    // array of dictonaries to hold data while downloding paginated data
    private var objectData : [JSONDictionary]
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    init()
    {
        self.objectData = [JSONDictionary]()
    }

    
    //Function that is a starting point to download paginated data
    func fetchFullData(objectType : ObjectType, completionHandler: @escaping ([JSONDictionary]?, ResultCode) -> Void) {
         // remove all data
         objectData.removeAll()
        
        //define url based on object type : people or starships or vehicles)
         let url = "http://swapi.co/api/\(objectType.rawValue)/"
        
        // call method to download paginated data
         fetchDataWithMultiPages(urlString: url, completionHandler: completionHandler)
    }

    
    // Generic Function to to download data from many urls, it appends the response into an array and return it back
    // note that data return from all urls should of the same type
    // The for loop initiate a download request per url and whne it receives feedback it appends it to the array
    // When all requests have returned , then the function returns teh array to the completionHandler
    func fetchDataWithMultiURLS<T>(request: DownloadRequest,  completionHandler: @escaping ([T]?, ResultCode) -> Void ){
        
        var tempData = [T]()
        var remainingDownloadTasks = request.urls.count // variable to hold how many reuests will be initiated
        
        for url in request.urls {
            downloadJSON(urlString: url ) {
                jsonData , resultCode in
                if resultCode == .success {
                    remainingDownloadTasks -= 1 // when request returns it decreases
                    if let result = jsonData?[request.resultExtractJSONKeyword] as? T
                    {
                        tempData.append(result)
                        if remainingDownloadTasks == 0 { completionHandler(tempData, .success)} // return all data
                    }else {
                        completionHandler(tempData,.failureRequiredDataNotFound) // if one or more field can't be read then it returns error
                    }
                }
                else {
                    completionHandler(tempData,resultCode) // return what you got with the error code
                }
            }
        }
    
    }
   
    // Funciton to downlaod paginated data 
    // It keeps calling itself until no more nextPage found 
    // Each time it appends the resturning result into an array 
    // when no more next pages it returns data to completion handler
    func fetchDataWithMultiPages(urlString: String, completionHandler: @escaping ([JSONDictionary]?, ResultCode) -> Void)
    {
        
        downloadJSON(urlString: urlString) {
            jsonData , resultCode in
            guard resultCode == .success  else {
                completionHandler(nil,resultCode)
                return
            }
            
            if let nextPage = jsonData?["next"] as? String {
                print(nextPage)
                if let results = jsonData?["results"] as? [JSONDictionary] {
                    for result in results {
                        self.objectData.append(result)
                    }
                }
                self.fetchDataWithMultiPages(urlString: nextPage, completionHandler: completionHandler)
            }
            else {
                // That was last page, now return full result
                completionHandler(self.objectData, .success)
            }
        }
    }
    
    // Funciton to download data from API 
    // data dowanlaod is converted to JSON Dictionary and sent to caller
    func downloadJSON(urlString: String, completionHandler: @escaping (JSONDictionary?, ResultCode) -> Void) {
        let url = URL(string: urlString)
        let task = session.dataTask(with: url!) { data, response, error in
            // TODO: implement error handeling for JSON Downaloder
            
            guard let response = response as? HTTPURLResponse else {
                // Missing HTTP response error
                completionHandler(nil, .failureNetworkError)
                return
            }
            
            
            if let data = data
            {
                if response.statusCode == 200
                {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                        completionHandler(jsonData, .success)
                    } catch { completionHandler(nil, .failureDataCantBeConvertedToJSON) }
                }
                else {
                    completionHandler(nil, .failureHTTPResponseError)
                }
            } else { completionHandler(nil,.failureDataMissing) }
            
        
      }
        task.resume()
    }
    
    
}
