//
//  WeatherList.swift
//  IBMWeatherProject
//
//  Created by Brian Glatt on 8/4/18.
//  Copyright © 2018 VUII. All rights reserved.
//

//Controls and manages weather view

import UIKit

class WeatherList : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var selectedWeathers: UICollectionView!
    @IBOutlet weak var locationLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return weather.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! WeatherCell
        
        //Left out id and weather abbr and id left of because of lack of relevance
        let selectedWeather = weather.object(at: indexPath.item) as! Weather;
        
        var weatherString = selectedWeather.date[1]+"/"+selectedWeather.date[2]+"\n\nAir Pressure: ";
        
        weatherString += String(selectedWeather.ap)+"\n"+"Humidity: "+String(selectedWeather.humidity);
        
        weatherString += "\n"+"Max: "+String(selectedWeather.maxTemp);
        
        weatherString += "\n"+"Min: "+String(selectedWeather.minTemp);
        
        weatherString += "\n"+"Temp: "+String(selectedWeather.temp);
        
         weatherString += "\n"+"Predictability: "+String(selectedWeather.predictability);
        
        weatherString += "\n"+"Visability: "+String(selectedWeather.visibility);
        
        weatherString += "\n"+"Weather: "+String(selectedWeather.weatherState);
        
        weatherString += "\n"+"Wind Direction: "+String(selectedWeather.windDirection)+", "+String(selectedWeather.compass);
        
        weatherString += "\n"+"Wind Speed: "+String(selectedWeather.windSpeed);
        
        cell.label.text=weatherString;
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/2, height: self.bounds.height)
    }
    
    @IBAction func back(_ sender: Any)
    {
        controller?.locationView.isHidden=false;
        controller?.weatherView.isHidden=true
        if(activeView=="WeatherFromLocation")
        {
            activeView="LocationFromMain";
        }
        else
        {
            activeView="LocationFromSearch";
        }
    }
}
