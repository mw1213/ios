//
//  ViewController.swift
//  WilkPogoda
//
//  Created by Student on 28/05/2020.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct Day: Codable{
        let id: Int
        let weather_state_name: String
        let weather_state_abbr: String
        let wind_direction_compass: String
        let created: String
        let applicable_date: String
        let min_temp: Float
        let max_temp: Float
        let the_temp: Float
        let wind_speed: Float
        let wind_direction: Float
        let air_pressure: Float
        let humidity: Int
        let visibility: Float
        let predictability: Int
    }
    
    struct Entry: Codable {
        let consolidated_weather: [Day]
        let time: String
        let sun_rise: String
        let sun_set: String
        let timezone_name: String
        let parent: Parent
        let sources: [Source]
        let title: String
        let location_type: String
        let woeid: Int
        let latt_long: String
        let timezone: String
    }
    
    struct Parent: Codable {
        let title: String
        let location_type: String
        let woeid: Int
        let latt_long: String
    }
    
    struct Source: Codable {
        let title: String
        let slug: String
        let url: String
        let crawl_rate: Int
    }
    
    var index = 0
    var entry: Entry?
    var weatherCount = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.button_prev_outlet.isEnabled = false
        loadData()
    }

    func updateView(index: Int){
        if let weather = self.entry?.consolidated_weather[index] {
            self.date_today.text = String(weather.applicable_date)
            self.weather_type.text = weather.weather_state_name
            self.label_temp_min.text = String(weather.min_temp)
            self.label_temp_max.text = String(weather.max_temp)
            self.wind_speed.text = String(weather.wind_speed)
            self.wind_direction.text = String(weather.wind_direction)
            self.air_pressure.text = String(weather.air_pressure)
            self.rainfall.text = String(weather.humidity)
        }
    }
    
    func initView(response: Entry?){
        self.entry = response
        if let count = self.entry?.consolidated_weather.count as? Int {
            self.weatherCount = count
        } else {
            self.button_next_outlet.isEnabled = false
        }
        self.updateView(index: index)
    }
    
    func loadData(){
        print("robi cokolwiek")
        let url = URL(string: "https://www.metaweather.com/api/location/523920/")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error{
                self.date_today.text = error.localizedDescription
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.date_today.text = "http error"
                return
            }
            guard let data = data, error == nil else{
                self.date_today.text = "other error"
                return
            }
            
            // decode JSON
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(Entry.self, from: data)
                self.entry = response
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.initView(response: self.entry)
            }
        }
        task.resume()
        print("robi cokolwiek")
    }

    
}


