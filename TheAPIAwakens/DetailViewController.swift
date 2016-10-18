//
//  DetailViewController.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 15/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import UIKit

// Field map
struct dataField {
    let jsonName: Field // name of field in results json
    let displayName: String // display name of field
    let nameLabel: UILabel // ui label to display field name
    let contentLabel: UILabel // uilabel to display feild content
}

class DetailViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {

    
    
    
    var navigationItemText: String = ""
    var objectType: ObjectType?
    
    // data elements in screen upper section
    let entityName = ""
    let entrityInfoHeader1 = ""
    let entrityInfoHeader2 = ""
    let entrityInfoHeader3 = ""
    let entrityInfoHeader4 = ""
    let entrityInfoHeader5 = ""
    
    let entrityInfoContent1 = ""
    let entrityInfocontent2 = ""
    let entrityInfoContent3 = ""
    let entrityInfoContent4 = ""
    let entrityInfoContent5 = ""
    
    // Lables to show data elements 
    
    @IBOutlet weak var mainEntityLabel: UILabel!
    @IBOutlet weak var entityInfoField1: UILabel!
    @IBOutlet weak var entityInfoField2: UILabel!
    @IBOutlet weak var entityInfoField3: UILabel!
    @IBOutlet weak var entityInfoField4: UILabel!
    @IBOutlet weak var entityInfoField5: UILabel!
    
    @IBOutlet weak var entityInfoFieldContent1: UILabel!
    @IBOutlet weak var entityInfoFieldContent2: UILabel!
    @IBOutlet weak var entityInfoFieldContent3: UILabel!
    @IBOutlet weak var entityInfoFieldContent4: UILabel!
    @IBOutlet weak var entityInfoFieldContent5: UILabel!
    
    // Label for samllest and argest
    @IBOutlet weak var smallestAndLargest: UILabel!
    @IBOutlet weak var smallestAndLargestFieldName: UILabel!
    
    
    // Field map
    var fieldsMap = [ObjectType:[dataField]]()

    //picker View
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //  status
    var stillDownloading = false
    
    // API Client object
    var dataManager : SwapiDataManager?

    //var data = [JSONResult]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = navigationItemText
        // picker view
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Field map
        setupFieldMap()
       
        // Data Download
        activityIndicator.layer.cornerRadius = 5.0
        activityIndicator.startAnimating()
    
        if !stillDownloading {
            stillDownloading = true
            dataManager?.loadData(objectType:objectType!) {
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.stillDownloading = false
                    if let dataManager = self.dataManager {
                        if dataManager.isThereData() {
                           // self.data = self.dataManager.objectData
                            self.displayInfo(row: 0)
                        }
                            self.pickerView.reloadAllComponents()
                    }
            
                }
            }
        }
        
        // display field names only
        displayInfo(row: 0)
    
    }
    
    
    func setupFieldMap() {
        
        fieldsMap.updateValue([
                dataField(jsonName: Field.birthYear, displayName: "Born", nameLabel: entityInfoField1, contentLabel: entityInfoFieldContent1),
                dataField(jsonName: Field.homeWorld, displayName: "Home", nameLabel: entityInfoField2, contentLabel: entityInfoFieldContent2),
                dataField(jsonName: Field.height, displayName: "Height", nameLabel: entityInfoField3, contentLabel: entityInfoFieldContent3),
                dataField(jsonName: Field.eyeColor, displayName: "Eyes", nameLabel: entityInfoField4, contentLabel: entityInfoFieldContent4),
                dataField(jsonName: Field.hairColor, displayName: "Hair", nameLabel: entityInfoField5, contentLabel: entityInfoFieldContent5)
            ]
            , forKey: ObjectType.people)

        fieldsMap.updateValue([
            dataField(jsonName: Field.make, displayName: "Make", nameLabel: entityInfoField1, contentLabel: entityInfoFieldContent1),
            dataField(jsonName: Field.cost, displayName: "Cost", nameLabel: entityInfoField2, contentLabel: entityInfoFieldContent2),
            dataField(jsonName: Field.length, displayName: "Length", nameLabel: entityInfoField3, contentLabel: entityInfoFieldContent3),
            dataField(jsonName: Field.vehicleClass, displayName: "Class", nameLabel: entityInfoField4, contentLabel: entityInfoFieldContent4),
            dataField(jsonName: Field.crew, displayName: "Crew", nameLabel: entityInfoField5, contentLabel: entityInfoFieldContent5)
            ]
            , forKey: ObjectType.vehicles)
        
        fieldsMap.updateValue([
            dataField(jsonName: Field.make, displayName: "Make", nameLabel: entityInfoField1, contentLabel: entityInfoFieldContent1),
            dataField(jsonName: Field.cost, displayName: "Cost", nameLabel: entityInfoField2, contentLabel: entityInfoFieldContent2),
            dataField(jsonName: Field.length, displayName: "Length", nameLabel: entityInfoField3, contentLabel: entityInfoFieldContent3),
            dataField(jsonName: Field.starshipClass, displayName: "Class", nameLabel: entityInfoField4, contentLabel: entityInfoFieldContent4),
            dataField(jsonName: Field.crew, displayName: "Crew", nameLabel: entityInfoField5, contentLabel: entityInfoFieldContent5)
            ]
            , forKey: ObjectType.starships)


    }
    
    
    // MARK: Picker View
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if stillDownloading {
            return 0
        } else {
                if let dataManager = self.dataManager {
                    return dataManager.dataCount()
                }
                else {
                    return 0
                }
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if let person = dataManager?.dataRow(row: row)
        { let name = person["name"] as? String
            return name
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        displayInfo(row: row)
    }
    
    
    // MARK: Display Info
    func displayInfo(row: Int) {
        
        // display field abels only
        mainEntityLabel.text = ""
        let currentFieldMap = fieldsMap[objectType!]
        for field in currentFieldMap! {
            field.nameLabel.text = field.displayName
            field.contentLabel.text = ""
        }
        // display content when download is finished
        if !stillDownloading {
            if let currentObject = dataManager?.dataRow(row: row) {
                let name = currentObject["name"] as? String
                mainEntityLabel.text = name
                for field in currentFieldMap! {
                    field.nameLabel.text = field.displayName
                    if let jsonData = currentObject[field.jsonName.rawValue] as? String {
                        field.contentLabel.text = jsonData
                    }
                }
            }
        
        // show smallest and largest
            if let dataManager = self.dataManager {
            let (smallest, largest) = dataManager.getSmallestAndLargest()
            
                smallestAndLargestFieldName.text = "  Smallest\n  Largest"
                smallestAndLargest.text = "\(smallest)\n\(largest)"
            
            }
        }
    }
    
    
}

    
   
    


