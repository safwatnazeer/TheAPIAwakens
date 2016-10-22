//
//  SwapiDataModel.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 16/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

// struct to hold info for one field
struct ParsedField {
    let fieldName : Field
    let fieldData: String
}


// Main data model class , it handels data retrived by API client and proivde it to View controller upon request.
class SwapiDataManager {
    
    private var objectData  : [JSONDictionary]      //All data of all members of current object type
    private var lastObjectTypeLoaded: ObjectType?   //current object type
    let apiClient = APIClient()
  
    init() {
        self.objectData = [JSONDictionary]()
        lastObjectTypeLoaded = nil
    }
    
    
    // Method to load data through use of APIClient
    // Logic avoids reloading data if it is already laoded last time
    func loadData(objectType:ObjectType, completionHandler: @escaping (ResultCode)-> Void){
        
        // check if same data type is requested again then no re-load
        if lastObjectTypeLoaded == objectType && objectData.count > 0 {
            completionHandler(.success)
        } else {
            // remove old data
            objectData.removeAll()
            self.lastObjectTypeLoaded = objectType // TODO: what if load failed ?? Fix it
            
            apiClient.fetchFullData(objectType: objectType) {
                data , resultCode in
                if resultCode == .success {
                    self.objectData = data!  // when success the  then data is for sure nil
                }
                completionHandler(resultCode)
                
            }
        }
    }
    
    // function to tell caller if there is data exists
    func isThereData() -> Bool {
        if objectData.count > 0 {
            return true
        } else {
            return false
        }
        
    }
    func dataCount() -> Int {
        return objectData.count
    }
    
    func dataRow(row: Int) -> JSONDictionary {
        return objectData[row]
    }
    
    
    // Function to sort data and show smallest and largest
    func getSmallestAndLargest() -> (String,String) {
        
        // decide which field will be used for size based on object type
        var sizeField : Field
        switch lastObjectTypeLoaded! {
            case .people:
                sizeField = .height
            case .starships, .vehicles:
                sizeField = .length
        }
        
        // get only name and size in an array of tuples
        let tempData = objectData.map() { (record:[String:AnyObject]) -> (String?, Double?) in
            
            if let name = record["name"] as? String, let sizeString  = record[sizeField.rawValue] as? String
            {
                return (name , Double(sizeString))
            }
            else {
                return (nil,nil)
            }
        }
        
        // filter out nil values for name or size
        let filteredData = tempData.filter() {
            if $0.0 == nil || $0.1 == nil {
                return false
            } else {
                return true
            }
        }
        // order data from smallest to largest , we are no nil values
        let orderedData = filteredData.sorted { (first, second) -> Bool
            in
            if first.1! < second.1! {return true} else {return false}
        }
        
        // return data
        if let smallest = orderedData.first?.0, let largest = orderedData.last?.0 {
            return (smallest,largest )
        } else {
            return ("","")
        }
    }
    
    //Function to receive a set of fields names and parse thier data and return in an array of fields
    func parseData(forFieldsList:[Field], atIndex: Int) -> [ParsedField]
    {
        
        let record = objectData[atIndex]
        var recordData = [ParsedField]()
        for currentField in forFieldsList {
            
            if let fieldData = record[currentField.rawValue] as? String {
                let parsedField = ParsedField(fieldName: currentField, fieldData: fieldData)
                recordData.append(parsedField)
            }
            else {
                // show default error text instead of field data in case not found
                let parsedField = ParsedField(fieldName: currentField, fieldData: "data not found")
                recordData.append(parsedField)

            }
        }
     
        return recordData
        
    }
    
    
    // Function to return associated/related data for a person
    // It parse the field data and get corresponding urls 
    // then call downlaodDatawithMultiURL to download them
    // Associated data like: home world, starships , vehicles, but can be more
    func getRelatedData(objectType: ObjectType, field: Field,index: Int,  completionHandler:@escaping ([String]?, ResultCode) -> Void ) {
    
        guard objectType == .people else {
            completionHandler(nil,.failureRelatedDataForNonPeople)
            return
        }
        
        let urls = parseFieldASArray(field: field, index: index)
        print(urls)
        if urls.count > 0 {
        
            let request = DownloadRequest(urls: urls, nextPageJSONKeyword: nil, resultExtractJSONKeyword: Field.name.rawValue)
            apiClient.fetchDataWithMultiURLS(request: request) {
                // TODO: add error handling
                data , resultCode in
                completionHandler(data, resultCode)
                }
        } else {
            completionHandler(nil,.success) // no realted data found , it is not an error
        }
     }
    
    // Helper function to return urls corresponding to a certain field
    func parseFieldASArray(field: Field, index: Int )-> [String]
    {
        var array = [String]()
        let record = objectData[index]
        // TODO: error handling if value is missing
        if let relatedItems = record[field.rawValue] as? [String] { array = relatedItems }
        else
        {
            if let relatedItem = record[field.rawValue] as? String { array.append(relatedItem) }
            else {
                // error:
            }
        }
        return array
    }
}




