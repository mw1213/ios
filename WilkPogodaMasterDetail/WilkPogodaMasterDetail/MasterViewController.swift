//
//  MasterViewController.swift
//  WilkPogodaMasterDetail
//
//  Created by Student on 09/06/2020.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

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


protocol AddNewCity: AnyObject
{
    func addCity(name: String, url: String)
}

class MasterViewController: UITableViewController, AddNewCity {

    
    var index = 0
    var entry: Entry?
    var weatherCount = 0
    
    
    
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var addViewController: AddNewCityController? = nil
    
    var cities = [String]()
    var cityUrls = [String]()
    var weatherStates = [Entry?]()



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cities.append("Warszawa")
        self.cityUrls.append("https://www.metaweather.com/api/location/523920/")
        self.cities.append("London")
        self.cityUrls.append("https://www.metaweather.com/api/location/44418/")
        self.cities.append("San Francisco")
        self.cityUrls.append("https://www.metaweather.com/api/location/2487956/")
        for i in 0...(self.cityUrls.count-1){
            self.loadData(cityUrl: self.cityUrls[i])
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    
    func addCity(name: String, url: String){
        self.cities.append(name)
        self.cityUrls.append(url)
        self.loadData(cityUrl: url)
        
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        cities.append("Moscow");
        let indexPath = IndexPath(row: cities.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if (indexPath.row < self.weatherStates.count){
                    let object = self.weatherStates[indexPath.row]
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    controller.entry = object
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
        if segue.identifier == "showAdd"{
            let vc = segue.destination as! AddNewCityController
            vc.delegateAction = self
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = cities[indexPath.row]
//still null
        if (indexPath.row < self.weatherStates.count){
            let temperature = self.weatherStates[indexPath.row]?.consolidated_weather[0].the_temp
            let weather_icon = self.weatherStates[indexPath.row]?.consolidated_weather[0].weather_state_abbr
            cell.detailTextLabel?.text = String(temperature!)
            cell.imageView?.image = UIImage(named: weather_icon!)
            cell.imageView?.setNeedsDisplay()
            }
        cell.textLabel!.text = city
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.cities.remove(at: indexPath.row)
            if(self.cityUrls.count>indexPath.row){
                self.cityUrls.remove(at: indexPath.row)
                self.weatherStates.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func loadData(cityUrl: String){
        let url = URL(string: cityUrl)!
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
                let response = try decoder.decode(Entry.self, from: data)
                self.weatherStates.append(response)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()

    }

}

