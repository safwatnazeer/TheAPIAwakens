//
//  HomeViewController.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 15/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var button: UIButton!
    
    let dataManager = SwapiDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let id = segue.identifier {
            if let vc = segue.destination as? DetailViewController {
                switch id {
                case "showPeople":
                    vc.objectType = ObjectType.people
                    vc.navigationItemText = "Characters"
                    vc.dataManager = dataManager
                case "showVehicles":
                    vc.objectType = ObjectType.vehicles
                    vc.navigationItemText = "Vehicles"
                    vc.dataManager = dataManager
                case "showStarships":
                    vc.objectType = ObjectType.starships
                    vc.navigationItemText = "Starships"
                    vc.dataManager = dataManager
                
                default:
                    break
                }
            }
        }
    }
    

}
