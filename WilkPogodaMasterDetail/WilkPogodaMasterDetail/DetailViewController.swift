//
//  DetailViewController.swift
//  WilkPogodaMasterDetail
//
//  Created by Student on 09/06/2020.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    
    var index = 0
    var entry: Entry?
    var weatherCount = 0
    var city: String?
    
    @IBOutlet weak var label_temp: UILabel!
    @IBOutlet weak var label_temp_max: UILabel!
    @IBOutlet weak var label_temp_min: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var weather_type: UILabel!
    @IBOutlet weak var wind_speed: UILabel!
    @IBOutlet weak var air_pressure: UILabel!
    @IBOutlet weak var wind_direction: UILabel!
    @IBOutlet weak var date_today: UILabel!
    @IBOutlet weak var rainfall: UILabel!
    @IBAction func button_next(_ sender: Any) {
        if (self.weatherCount != 0 && self.index != self.weatherCount - 1){
            self.index += 1
            self.updateView(index: self.index)
            button_prev_outlet.isEnabled = true
            if (self.index == self.weatherCount - 1) {
                button_next_outlet.isEnabled = false
            }
        }
    }
    
    @IBOutlet weak var button_prev_outlet: UIButton!
    @IBOutlet weak var button_next_outlet: UIButton!
    @IBAction func button_prev(_ sender: Any) {
        if (self.index > 0) {
            self.index -= 1
            self.updateView(index: self.index)
            if (self.index == 0){
                button_prev_outlet.isEnabled = false
            } else{
                button_prev_outlet.isEnabled = true
            }
        }
    }


    func configureView() {
        // Update the user interface for the detail item.
        if let entry = self.entry {
            self.button_prev_outlet.isEnabled = false
            if let count = self.entry?.consolidated_weather.count {
                self.weatherCount = count
            } else {
                self.button_next_outlet.isEnabled = false
            }
            self.updateView(index: 0)
        }
        if let cityName = self.city{
            navigationItem.title = cityName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: NSDate? {
        didSet {

            // Update the view.
            configureView()
        }
    }

    func updateView(index: Int){
        if let weather = self.entry?.consolidated_weather[index] {
            self.label_temp.text = "Temperature:" + String(weather.the_temp)
            self.date_today.text = String(weather.applicable_date)
            self.weather_type.text = "Type: " +  weather.weather_state_name
            self.label_temp_min.text = "Temp min:" + String(weather.min_temp)
            self.label_temp_max.text = "Temp max:" + String(weather.max_temp)
            self.wind_speed.text = "Wind speed:" + String(weather.wind_speed)
            self.wind_direction.text = "Wind deirection:" + String(weather.wind_direction_compass)
            self.air_pressure.text = "Air pressure: " + String(weather.air_pressure)
            self.rainfall.text = "Humidity:" +  String(weather.humidity)
            self.image.image = UIImage(named: weather.weather_state_abbr)!
            self.image.setNeedsDisplay()
        }
    }
    
    
}

