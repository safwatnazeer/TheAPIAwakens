//
//  SwapiDataModel.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 16/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:AnyObject]
typealias HandlerWithJSONDictionary = (JSONDictionary) -> Void
typealias Handler = () -> Void
typealias HandlerWithArrayJSONDictionary = ([JSONDictionary]) -> Void

struct ParsedField {
    let fieldName : Field
    let fieldData: String
}

struct ParsedData {
    let recordData : [ParsedField]
}

class SwapiDataManager {
    
    private var objectData  : [JSONDictionary]
    private var lastObjectTypeLoaded: ObjectType?
    
  
    init() {
        self.objectData = [JSONDictionary]()
        lastObjectTypeLoaded = nil
    }
    
    
    // Methid to load data through use of APIClient
    // Logic avoid reloading data if it is already laoded last time
    func loadData(objectType:ObjectType, completionHandler: @escaping Handler){
        
        // check if same data type is requested again then no re-load
        if lastObjectTypeLoaded == objectType {

            completionHandler()
        } else {
            // remove old data
            objectData.removeAll()
            self.lastObjectTypeLoaded = objectType // TODO: what if load failed ?? Fix it
            let apiClient = APIClient()
            apiClient.downloadData(objectType: objectType) {
                data in
                    print("data is loaded .. ")
                    self.objectData = data
                    
                completionHandler()
            
            }
        }
    }
    
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
        print(orderedData)
        // return data
        if let smallest = orderedData.first?.0, let largest = orderedData.last?.0 {
            return (smallest,largest )
        } else {
            return ("","")
        }
    }
    
    func parseJSON(objectType: ObjectType, index: Int) -> [ParsedField]
    {
        
        let fieldsList = objectType.fields
        let record = objectData[index]
        var recordData = [ParsedField]()
        for currentField in fieldsList {
            let parsedField = ParsedField(fieldName: currentField, fieldData: record[currentField.rawValue] as! String)
            recordData.append(parsedField)
        }
        print(recordData)
        return recordData
        
    }

}
