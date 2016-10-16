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
    
    
    
    // Field map
    var fieldsMap = [ObjectType:[dataField]]()

    //picker View
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // global status
    var stillDownloading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = navigationItemText
        // picker view
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Field map
        setupFieldMap()
        
        // Data Download
        allPeople.removeAll()
        activityIndicator.startAnimating()
        
        if !stillDownloading {
            stillDownloading = true
            downloadJson(objectType: objectType!)
        }
        handlerAfterGettingAllData =
        {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.stillDownloading = false
                self.pickerView.reloadAllComponents()
            }
        }
                
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
            return allPeople.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let person = allPeople[row]
        let name = person["name"] as? String
        return name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        displayInfo(row: row)
    }
    
    
    // MARK: Display Info
    func displayInfo(row: Int) {
        
        
        let currentObject = allPeople[row]
        
        let name = currentObject["name"] as? String
        mainEntityLabel.text = name
        
        let currentFieldMap = fieldsMap[objectType!]
        for field in currentFieldMap! {
            field.nameLabel.text = field.displayName
            if let jsonData = currentObject[field.jsonName.rawValue] as? String {
                field.contentLabel.text = jsonData
            }
            
        }
        
        
    }
    
    
}

    
   
    


