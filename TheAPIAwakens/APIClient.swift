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




class APIClient {
    
   private var objectData : [JSONDictionary]
      init()
    {
        self.objectData = [JSONDictionary]()
    }

    func downloadData(objectType : ObjectType, completionHandler: @escaping HandlerWithArrayJSONDictionary) {
       
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: config)
        
        let url = "http://swapi.co/api/\(objectType.rawValue)/"
         getNextPage(urlString: url, session: session, completionHandler: completionHandler)
    }

    func getNextPage(urlString: String, session: URLSession , completionHandler: @escaping HandlerWithArrayJSONDictionary)
    {
        
        downloadJSON(urlString: urlString, session: session) {
            jsonData in
            
            if let nextPage = jsonData["next"] as? String {
                print(nextPage)
                if let results = jsonData["results"] as? [[String:AnyObject]] {
                    for result in results {
                        self.objectData.append(result)
                    }
                }
                self.getNextPage(urlString: nextPage, session: session, completionHandler: completionHandler)
            }
            else {
                print("That was last one ---- ")
                completionHandler(self.objectData)
            }
        }
    }
    
    func downloadJSON(urlString: String, session: URLSession , completionHandler: @escaping HandlerWithJSONDictionary) {
        let url = URL(string: urlString)
        let task = session.dataTask(with: url!) { data, response, error in
            // TODO: implement error handeling for JSON Downaloder
            if let jsonData = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject]
            {
                completionHandler(jsonData)
            } else {
                // TODO: Error can't convert data to JSON
                print ("Error can't convert data to JSON")
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
 
 var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
 print(json)
 //let results = json?["results"] as! [[String:AnyObject]]
 for result in results {
 let name:String = result["name"] as! String
 print(name)
 }
 */
