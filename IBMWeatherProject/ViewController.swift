//
//  ViewController.swift
//  IBMWeatherProject
//
//  Created by Brian Glatt on 8/3/18.
//  Copyright © 2018 VUII. All rights reserved.
//


 //Given more time I would have changed the layout to use a scrollView instead to simplify page switching
//Given more time would have set up loading screens and managers for synchronous processes

import UIKit
import CoreLocation


//Stores viewable locations
struct Location
{
    let woeid : Int;
    let location : String;
    let type : String;
    
    init(j : [String : Any])
    {
        woeid = (j["woeid"] as? Int)!
        location = (j["title"] as? String)!
        type = (j["location_type"] as? String)!
    }
}

//Stores weather information
struct Weather
{
    let ap : Float;
    let date : [String]
    let humidity : Int
    let maxTemp : Float;
    let minTemp : Float;
    let predictability : Int
    let temp : Float;
    let visibility : Float;
    let weatherState : String;
    let windDirection : Float;
    let compass : String;
    let windSpeed : Float
    
    init(j : [String : Any])
    {
        ap = (j["air_pressure"] as? NSNumber)!.floatValue
        date = (j["applicable_date"] as? String)!.split(separator:"-").map(String.init);
        humidity = (j["humidity"] as? Int)!
        maxTemp = (j["max_temp"] as? NSNumber)!.floatValue
        minTemp = (j["min_temp"] as? NSNumber)!.floatValue
        predictability = (j["predictability"] as? Int)!
        temp = (j["the_temp"] as? NSNumber)!.floatValue
        visibility = (j["visibility"] as? NSNumber)!.floatValue
        weatherState = (j["weather_state_name"] as? String)!
        windDirection = (j["wind_direction"] as? NSNumber)!.floatValue
        compass = (j["wind_direction_compass"] as? String)!
        windSpeed = (j["wind_speed"] as? NSNumber)!.floatValue
    }
}

//Stores saved search data
//Given more time would have created and stored in JSON format
struct SavedSearch
{
    let text : String;
    let date : Double;
    let good : Bool;
    
    init(i : [String])
    {
        text = i[0];
        date = Double(i[1])!
        if(i[2]=="true")
        {
            good = true;
        }
        else
        {
            good = false;
        }
    }
}

class ViewController: UIViewController,CLLocationManagerDelegate
{
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var locationView: LocationList!
    
    @IBOutlet weak var weatherView: WeatherList!
    
    @IBOutlet weak var searchView: SearchView!
    
    @IBOutlet weak var historyView: HistoryView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupLocationManager()
        manualDecode();
        
        controller=self;
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //Gets codes for weather based on location
    func getIDsOnLocation(lat : String, lon : String)
    {
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong="+lat+","+lon) else {return};
        
        state="Loading";
        
        _ = URLSession.shared.dataTask(with: url)
        {
            (data, response, error) in
            
            if let data = data
            {
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] else {return}
                    locations.removeAllObjects();
                    for l in json
                    {
                        locations.add(Location(j : l));
                    }
                    
                    DispatchQueue.main.async()
                    {
                        activeView="LocationFromMain";
                        state="Nothing";
                        self.mainView.isHidden=true;
                        self.locationView.isHidden=false;
                        self.locationView.selectedLocations.contentOffset = CGPoint(x: -self.locationView.selectedLocations.contentInset.left, y: -self.locationView.selectedLocations.contentInset.top);
                        self.locationView.selectedLocations.reloadData();
                        
                    }
                }
                catch
                {
                    print(error)
                    state="Nothing";
                }
            }
        }.resume()
    }
    
    /*
     Loads and displays weather
     
     Note: Shows Today's weather as well as next 5 Days
     */
    func getWeather(loc: String, name: String)
    {
        guard let url = URL(string: "https://www.metaweather.com/api/location/"+loc) else {return};
        
        state="Loading";
        
        activeLocation=name;
        
        _ = URLSession.shared.dataTask(with: url)
        {
            (data, response, error) in
            
            if let data = data
            {
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {return}
                    weather.removeAllObjects();
                    let cw=json["consolidated_weather"] as? [[String : Any]]
                    for w in cw!
                    {
                        weather.add(Weather(j : w));
                    }
                    
                    DispatchQueue.main.async()
                    {
                        if(activeView=="LocationFromMain")
                        {
                            activeView="WeatherFromLocation";
                        }
                        else if(activeView=="LocationFromSearch")
                        {
                            activeView="WeatherFromLocationFromSearch";
                        }
                            
                        state="Nothing";
                        self.weatherView.locationLabel.text=activeLocation;
                        
                        self.locationView.isHidden=true;
                        self.weatherView.isHidden=false;
                        self.weatherView.selectedWeathers.contentOffset = CGPoint(x: -self.weatherView.selectedWeathers.contentInset.left, y: -self.weatherView.selectedWeathers.contentInset.top);
                        self.weatherView.selectedWeathers.reloadData();
                            
                    }
                    
                    
                    
                    
                }
                catch
                {
                    print(error)
                    state="Nothing";
                }
            }
            }.resume()
    }
    
    //Gets codes for weather based on keyword
    func getIDsFromName(name: String)
    {
        guard let url = URL(string: "https://www.metaweather.com//api/location/search/?query="+name) else {return};
        
        state="Loading";
        
        activeLocation=name;
        
        _ = URLSession.shared.dataTask(with: url)
        {
            (data, response, error) in
            
            if let data = data
            {
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] else {return}
                    locations.removeAllObjects();
                    for l in json
                    {
                        locations.add(Location(j : l));
                    }
                    if(locations.count==0)
                    {
                        savedHistory.setObject(SavedSearch.init(i: [name,String(NSDate().timeIntervalSince1970),"false"]), forKey: name as NSCopying)
                    }
                    else
                    {
                        savedHistory.setObject(SavedSearch.init(i: [name,String(NSDate().timeIntervalSince1970),"true"]), forKey: name as NSCopying)
                    }
                    
                    self.manualEncode();
                    
                    DispatchQueue.main.async()
                        {
                            activeView="LocationFromSearch";
                            state="Nothing";
                            self.searchView.isHidden=true;
                            self.locationView.isHidden=false;
                            self.locationView.selectedLocations.reloadData();
                    }
                }
                catch
                {
                    print(error)
                    state="Nothing";
                }
            }
            }.resume()
    }

    func setupLocationManager()
    {
        lm.requestAlwaysAuthorization()
        
        lm.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            lm.delegate = self
            lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            lm.startUpdatingLocation()
        }
    }
    
    /*
     Search history stored as String on local data.  Data is loaded and put into useable format
     upon loading
     
     Given more time would have used JSON storage instead and would have utilized a more efficient
     selection algorithm and synchronous code
    */
    func manualDecode()
    {
        let temp = prefs.string(forKey: "History");
        let objects = temp?.split(separator:":").map(String.init);
        
        if(objects==nil)
        {
            return;
        }
        
        savedHistory.removeAllObjects();
        
        for o in objects!
        {
            savedHistory.setObject((SavedSearch.init(i: o.split(separator:",").map(String.init))), forKey: o.split(separator:",").map(String.init)[0] as NSCopying)
        }
    }
    
    /*
     Saves new history objects in local storage
     
     Given more time would have stored as JSON and preformed only single addition rather then
     readding all
    */
    func manualEncode()
    {
        var temp="";
        var count=0;
        for s in savedHistory
        {
            
            temp += ((s.value as? SavedSearch)?.text)!+","+String(((s.value as? SavedSearch)?.date)!)+",";
            if((s.value as? SavedSearch)?.good)!
            {
                temp += "true";
            }
            else
            {
                temp += "false";
            }
            count += 1;
            if(count<savedHistory.count)
            {
                temp += ":";
            }
        }
        
        prefs.set(temp, forKey: "History");
    }
    //Displays message when location sevices are not avalible for app
    func showNotEnabledWarning()
    {
        mainView.isUserInteractionEnabled=false;
        messageView.isHidden=false;
        messageLabel.text="Location Sevices are not Avalible for this Device";
    }
    //Displays message when location sevices are not allowed for app
    func showNotAcceptedWarning()
    {
        mainView.isUserInteractionEnabled=false;
        messageView.isHidden=false;
        messageLabel.text="Location Sevices are not Enabled for this Device";
    }
    
    
    @IBAction func findLocation(_ sender: Any)
    {
        if state != "Nothing"
        {
            return;
        }
        else if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
                case .notDetermined, .restricted, .denied:
                    showNotAcceptedWarning();
                
                
                case .authorizedAlways, .authorizedWhenInUse:
                    getIDsOnLocation(lat: String(format: "%f", (lm.location?.coordinate.latitude)!), lon: String(format: "%f", (lm.location?.coordinate.longitude)!))
            }
        }
        else
        {
            showNotEnabledWarning()
        }
    }
    @IBAction func chooseLocation(_ sender: Any)
    {
        if state != "Nothing"
        {
            return;
        }
        else
        {
            searchView.isHidden=false;
            mainView.isHidden=true;
            activeView="Search";
        }
    }
    
    //Closes message view
    @IBAction func closeMessage(_ sender: Any)
    {
        mainView.isUserInteractionEnabled=true;
        messageView.isHidden=true;
    }
}
