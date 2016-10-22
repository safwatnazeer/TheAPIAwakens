//
//  DetailViewController.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 15/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import UIKit

// Field map struct
struct dataField {
    let jsonName: Field // name of field in results json
    let displayName: String // display name of field
    let nameLabel: UILabel // ui label to display field name
    let contentLabel: UILabel // uilabel to display feild content
}

class DetailViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource , UITextViewDelegate {

    
    var navigationItemText: String = ""
    var objectType: ObjectType?  // passed from home controller
    
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
    
    // Label for samllest and largest
    @IBOutlet weak var smallestAndLargest: UILabel!
    @IBOutlet weak var smallestAndLargestFieldName: UILabel!
    
    // TextView
    @IBOutlet weak var relatedStarships: UITextView!
    @IBOutlet weak var relatedVehicles: UITextView!
    
    // Conversion buttons
    @IBOutlet weak var conversionButtonSV: UIStackView!
    @IBOutlet weak var creditButton: UIButton!
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    
    
    // Field map
    var fieldsMap = [ObjectType:[dataField]]()

    //picker View
    @IBOutlet weak var pickerView: UIPickerView!
    
    //activity indicator
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
                resultCode in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.stillDownloading = false
                    // Handel error
                    if resultCode != .success {
                        self.showErrorMessage(message: resultCode.rawValue)
                        return
                    } else {
                        // load data in picker view and display first record
                        if let dataManager = self.dataManager
                        {
                            if dataManager.isThereData() {
                                self.displayInfo(row: 0)
                            }
                            self.pickerView.reloadAllComponents()
                        }
                    }
            
                }
            }
        }
        
        
        
        // display blank fields (names and contents)
        displayInfo(row: 0)
    
        
        
    }
    
    // Setup the mapping between data fields and screen fields for each object type
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
    
    
    // MARK: Display Info details of a selection
    func displayInfo(row: Int)
    {
        
        // clear all text and labels and hide buttons till loading is complete
        mainEntityLabel.text = ""
        relatedVehicles.text = ""
        relatedStarships.text = ""
        
        // hide conversion buttons
        conversionButtonSV.isHidden = true
        metricButton.isHidden = true
        englishButton.isHidden = true
        
        // clear all text shown
        let currentFieldMap = fieldsMap[objectType!]
        for field in currentFieldMap! {
            field.nameLabel.text = " "
            field.contentLabel.text = " "
        }
        // display content only when download is finished
        guard  !stillDownloading  else {return }
        if let parsedData = dataManager?.parseData(forFieldsList: self.objectType!.fields, atIndex: row) {
            let name = parsedData[0].fieldData  // always name is the first returned field
            mainEntityLabel.text = name
            
            for uiField in currentFieldMap! {
                uiField.nameLabel.text = uiField.displayName
                for dataField in parsedData {
                    if dataField.fieldName == uiField.jsonName {
                        uiField.contentLabel.text = dataField.fieldData
                    }
                }
            }
        }
        
        // show smallest and largest
        if let dataManager = self.dataManager {
        let (smallest, largest) = dataManager.getSmallestAndLargest()
        
            smallestAndLargestFieldName.text = "  Smallest\n  Largest"
            smallestAndLargest.text = "\(smallest)\n\(largest)"
        
        }
        // show related data
        if objectType == .people {
            conversionButtonSV.isHidden = true
            showRelatedData(row:row) }
        else { showExchangeRate() }
        
        // show and highlight metric and english 
        metricButton.isHidden = false
        englishButton.isHidden = false
        metricButton.setTitleColor(UIColor.white, for: .normal)
        englishButton.setTitleColor(UIColor.gray, for: .normal)
        // TODO: replace this with a better solution
        let button = UIButton()
        button.setTitle("Metric", for: .normal)
       // convertUnits(button)
        
    }
    
    //Function to show addiotnal info that need to be downlaoded separately 
    // home world, startships , vehicles
    func showRelatedData(row: Int) {
        relatedStarships.isHidden = true
        relatedVehicles.isHidden = true
        
        if let dataManager = self.dataManager {
            // show related Vehicles
            dataManager.getRelatedData(objectType: objectType! , field: .vehicles ,index: row)
            {
                vehicles , resultCode in
                DispatchQueue.main.async {
                    if resultCode == .success {
                        if let vehicles = vehicles {
                                var text = "Vehicles:\n"
                                for v in vehicles { text += "-\(v)\n"}
                                self.relatedVehicles.text = text
                                self.relatedVehicles.isHidden = false
                        }
                    } else {
                        self.showErrorMessage(message: resultCode.rawValue)
                    }
                }
            }
            // show related Startships
            dataManager.getRelatedData(objectType: objectType! , field:.starships ,index: row) {
                starships, resultCode in
                DispatchQueue.main.async {
                    if resultCode == .success {
                        if let starships = starships {
                                var text = "Starships:\n"
                                for v in starships { text += "-\(v)\n"}
                                self.relatedStarships.text = text
                                self.relatedStarships.isHidden = false
                        }
                    } else {
                        self.showErrorMessage(message: resultCode.rawValue)
                    }
                }
            }
            
            // show home world
            // first clear field till home world load is done
            self.entityInfoFieldContent2.text = " "
            dataManager.getRelatedData(objectType: objectType! , field:.homeWorld ,index: row) {
                homeWorld, resultCode in
                DispatchQueue.main.async {
                    if resultCode == .success {
                        if let homeWrold = homeWorld {
                                self.entityInfoFieldContent2.text = homeWrold[0] // array must have one home wolrd only
                        }
                    } else {
                        self.showErrorMessage(message: resultCode.rawValue)
                    }
                }
            }
            
        }
    }
    
    //Function to show exchange rate using existing text views that normally used to show vehicles and startships
    func showExchangeRate() {
        
        // reuse existing fields for exchange rate
        relatedVehicles.text = "Exchange Rate =\nGalagtic credits to USD "
        relatedVehicles.isHidden = false
        
        relatedStarships.text = "20.0"  // default exchaneg rate
        relatedStarships.isHidden = false
        relatedStarships.isEditable = true
        relatedStarships.delegate = self
        
        conversionButtonSV.isHidden = false
        
        creditButton.setTitleColor(UIColor.white, for: .normal)
        usdButton.setTitleColor(UIColor.gray, for: .normal)
        
        
        
        
    }
    
    // Fucntion to convert Credits to USD
    @IBAction func convertCurrency(_ sender: AnyObject) {
        
        let row = pickerView.selectedRow(inComponent: 0)
        if let cost = dataManager?.parseData(forFieldsList: [.cost], atIndex: row)
        {
        let costData = cost[0].fieldData
        if let costValue = Double(costData){
            if let sender = sender as? UIButton, let label = sender.titleLabel?.text
            {
                switch label{
                    case "Credits":
                        entityInfoFieldContent2.text = costData
                        creditButton.setTitleColor(UIColor.white, for: .normal)
                        usdButton.setTitleColor(UIColor.gray, for: .normal)
                    case "USD":
                        creditButton.setTitleColor(UIColor.gray, for: .normal)
                        usdButton.setTitleColor(UIColor.white, for: .normal)
                        if let rateValue = Double(relatedStarships.text) {
                            if rateValue > 0 {
                                let costUSD = costValue/rateValue
                                entityInfoFieldContent2.text = "\(costUSD)"
                            }
                            else {
                                showErrorMessage(message: "Exchange rate can't be negative")
                                entityInfoFieldContent2.text = " "
                            }
                        } else {
                            entityInfoFieldContent2.text = " "
                            showErrorMessage(message: "You entered invalid number for exchange rate")
                    }
                default:
                    break
                }
            }
        }
        }
    }
    
    // Fucntion to convert metric to english
    @IBAction func convertUnits(_ sender: AnyObject) {
        
        let row = pickerView.selectedRow(inComponent: 0)
        var sizeField: Field
        switch objectType! {
        case .people: sizeField = .height
        case .starships, .vehicles:   sizeField = .length
            
        }
        
        if let size = dataManager?.parseData(forFieldsList: [sizeField], atIndex: row) {
            let sizeData = size[0].fieldData
            if var sizeValue = Double(sizeData){
                
                if  (objectType! == .people) { sizeValue = sizeValue / 100 } // height is in cm for people
                if let sender = sender as? UIButton, let label = sender.titleLabel?.text {
                    switch label{
                    case "Metric":
                        entityInfoFieldContent3.text = "\(sizeValue)m"
                        metricButton.setTitleColor(UIColor.white, for: .normal)
                        englishButton.setTitleColor(UIColor.gray, for: .normal)
                    case "English":
                        metricButton.setTitleColor(UIColor.gray, for: .normal)
                        englishButton.setTitleColor(UIColor.white, for: .normal)
                        let conversionRate = 3.28 // 1m = 3.28 feet
                        let englishValue = sizeValue * conversionRate
                        let englishwith2Decimals = (englishValue*100).rounded()/100
                        
                        entityInfoFieldContent3.text = "\(englishwith2Decimals)f"
                        
                    default:
                        break
                    }
                }
            }
        }
    }
    
    
    // Method to display error message
    func showErrorMessage(message: String) {
        
        let alert = UIAlertController(title: "Error !!", message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: text view delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            relatedStarships.resignFirstResponder()
        }
        return true
    }
    
    
}






