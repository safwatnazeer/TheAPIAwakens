//
//  ViewController.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 11/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import UIKit

public let NetworkingErrorDomain = "com.safwat.TheAPIAwaken.NetworkingError"
public let MissingHTTPResponseError = 10

class ViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource , URLSessionDelegate{

    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    
    var selectedNumer: Int = 0
    let list = [1,2,3,4]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func testApi() {
    
        
        let url = URL(string: "http://swapi.co/api/planets/\(selectedNumer)/")
        let urlRequest = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: config)
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
            
        do
        {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
            print("json: --> \(json)")
            var displayText = ""
            if let name =  json?["name"] as? String {
                displayText += "\(name)\n"
            }
            if let films = json?["films"] as? [String] {
                for film in films {
                    displayText += "\(film)\n"
                }
            }
            DispatchQueue.main.async {
                self.textView.text = displayText
            }
            
        } catch let error as NSError{
         print("Error for Json: -->  \(error)")
        }
        }
        }
        task.resume()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("selection: \(row)")
        selectedNumer = list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(list[row])"
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Option: \(list[row])"
        print("created label ....")
        
        return label
    }
    
    */
    
}
