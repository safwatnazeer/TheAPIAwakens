//
//  APIClient.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 16/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

typealias JSONResult = [String:AnyObject]
typealias Handler = () -> Void

var allPeople = [JSONResult]()
var handlerAfterGettingAllData : Handler? = nil

protocol APIClient {
    var objectType : ObjectType {get}
  // var configuration: URLSessionConfiguration { get }
  // var session: URLSession { get }
}
extension APIClient {
    func downloadJson() {
        //let baseURL = URL(string: "http://swapi.co/api/")
        
        //let typeToDownload = "\(objectType.rawValue)/"
        
        //let url = URL(string: typeToDownload, relativeTo: baseURL)
        //let urlRequest = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: config)
        
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
        
        
        // First Download
        let nextPageUrl = "http://swapi.co/api/\(objectType.rawValue)/"
        //var json: JSONResult = [:]
        
        getNextPage(urlString: nextPageUrl, session: session)
    }




    func getNextPage(urlString: String, session: URLSession ) {
        
        let url = URL(string: urlString)
        let task = session.dataTask(with: url!) { data, response, error in
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject]
            
            if let nextPage = json?["next"] as? String {
                print(nextPage)
                if let people = json?["results"] as? [[String:AnyObject]] {
                    for person in people {
                        allPeople.append(person)
                    }
                }
                self.getNextPage(urlString: nextPage, session: session)
                
            }
            else {
                print("That was last one ---- ")
                handlerAfterGettingAllData!()
            }
            
        }
        task.resume()
        
    
}
}
