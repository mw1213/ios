//
//  AddNewCityController.swift
//  WilkPogodaMasterDetail
//
//  Created by Student on 18/06/2020.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
struct City: Codable{
    let distance: Int
    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String
}



class AddNewCityController: UIViewController{
    
    var cities = [City?]()
    weak var delegateAction: AddNewCity! = nil
    @IBOutlet weak var latitude: UITextField!
    
    @IBOutlet weak var longitude: UITextField!
    @IBAction func add(_ sender: Any) {
        self.loadData()
    }

    func sendCity(){
        let singleCity = cities[0]
        let url = "https://www.metaweather.com/api/location/" + String(singleCity!.woeid)
        delegateAction?.addCity(name: singleCity!.title, url: url)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    func loadData(){
        var myUrl = "https://www.metaweather.com/api/location/search/?lattlong="
        myUrl.append(contentsOf: latitude.text!)
        myUrl.append(",")
        myUrl.append(contentsOf: longitude.text!)
        let url = URL(string: myUrl)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error{
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            guard let data = data, error == nil else{
                return
            }
            
            // decode JSON
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(Array<City>.self, from: data)
                self.cities = response

            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.sendCity()
            }
        }
        task.resume()
        
    }

}
