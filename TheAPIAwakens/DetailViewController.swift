//
//  DetailViewController.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 15/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    let navigationItemText: String = ""
    
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
    
    
    //picker View
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Safwat"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
