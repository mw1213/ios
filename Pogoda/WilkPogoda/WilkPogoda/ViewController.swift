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

    func updateView(){
        
    }
    func loadData(){
        print("robi cokolwiekddddddd")
        let url = URL(string: "https://www.metaweather.com/api/location/523920/")
        if let url = URL(string: "https://www.metaweather.com/api/location/523920/") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(Entry.self, from: data)
                        for day in parsedJSON.days {
                            print(day.value.id)
                            print(day.value.humidity)
                        }
                    } catch {
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.updateView()
                }
                }.resume()
        }
        print("robi cokolwiek")
    }

    
}



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
    let days: [String: Day]
}

