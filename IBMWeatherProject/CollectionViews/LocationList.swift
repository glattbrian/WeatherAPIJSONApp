//
//  LocationList.swift
//  IBMWeatherProject
//
//  Created by Brian Glatt on 8/3/18.
//  Copyright © 2018 VUII. All rights reserved.
//

//Controls and manages location results
import UIKit

class LocationList : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var selectedLocations: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return locations.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! LocationCell
        
        let location=locations.object(at: indexPath.item) as! Location;
        
        cell.button.setTitle(String(location.woeid)+", "+location.location+", "+location.type, for: .normal);
        
        cell.button.addTarget(self, action: #selector(self.viewDetails), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight/6)
    }
    
    @objc func viewDetails(sender: UIButton!)
    {
        let text = sender.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).split(separator:",").map(String.init);
        
        controller?.getWeather(loc: text![0], name: text![1]);
        
    }
    
    @IBAction func backToMain(_ sender: Any)
    {
        if(activeView=="LocationFromMain")
        {
            controller?.mainView.isHidden=false;
            controller?.locationView.isHidden=true;
            activeView="MainMenu";
        }
        else
        {
            controller?.searchView.isHidden=false;
            controller?.locationView.isHidden=true;
            activeView="Search";
            controller?.searchView.tableView.reloadData();
        }
    }
    
    
    
}
