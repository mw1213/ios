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

struct City2: Codable{
    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String
}


class AddNewCityController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var cities = [City?]()
    var cities2 = [City2?]()
    
    var test = ["1", "w"]
    weak var delegateAction: AddNewCity! = nil

    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }

    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func add(_ sender: Any) {
        self.loadData()
    }


    @IBAction func addAsCityName(_ sender: Any) {
        self.loadDataForCity()
    }
    func sendCity(){
        let singleCity = cities[0]
        let url = "https://www.metaweather.com/api/location/" + String(singleCity!.woeid)
        delegateAction?.addCity(name: singleCity!.title, url: url)
    }
    

    //MARK: tableView delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities2.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cityCell")
        cell.textLabel?.text = cities2[indexPath.row]!.title
        return cell
    
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = self.cities2[indexPath.row]!.title
        let woeid = self.cities2[indexPath.row]!.woeid
        let url = "https://www.metaweather.com/api/location/" + String(woeid)
        delegateAction?.addCity(name: name, url: url)
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
    func loadDataForCity(){
        var myUrl = "https://www.metaweather.com/api/location/search/?query="
        myUrl.append(contentsOf: cityName.text!)
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
                let response = try decoder.decode(Array<City2>.self, from: data)
                self.cities2 = response
                
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                print(self.cities2)
                self.tableView.reloadData()
            }
        }
        task.resume()
        
    }

}
