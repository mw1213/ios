//
//  ViewController.swift
//  WilkPogoda
//
//  Created by Student on 28/05/2020.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var label_temp_max: UILabel!
    
    @IBOutlet weak var label_temp_min: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var weather_type: UILabel!
    
    @IBOutlet weak var wind_speed: UILabel!
    
    @IBOutlet weak var air_pressure: UILabel!

    @IBOutlet weak var rainfall: UILabel!

    @IBOutlet weak var wind_direction: UILabel!

    @IBOutlet weak var date_today: UILabel!
    
    @IBAction func button_next(_ sender: Any) {
    }
    
    @IBAction func button_prev(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

