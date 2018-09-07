//
//  HistoryView.swift
//  IBMWeatherProject
//
//  Created by Brian Glatt on 8/5/18.
//  Copyright © 2018 VUII. All rights reserved.
//

//Manages and updates the viewable search history

import UIKit

class HistoryView : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var selectedHistory: UICollectionView!
    
    var sortedHistory : [SavedSearch] = [];
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return sortedHistory.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! HistoryCell
        
        let search=sortedHistory[indexPath.item];
        
        cell.text.text=search.text;
        
        let date=Date(timeIntervalSince1970: search.date);
        let calendar = Calendar.current
        
        var month = String(calendar.component(.month, from: date));
        
        if(month.count<2)
        {
            month = "0"+month;
        }
        
        var day = String(calendar.component(.day, from: date));
        
        if(day.count<2)
        {
            day = "0"+day;
        }
        
        let year = String(calendar.component(.year, from: date));
        var hour = String(calendar.component(.hour, from: date));
        
        if(hour.count<2)
        {
            hour = "0"+hour;
        }
        
        var minute = String(calendar.component(.month, from: date));
        
        if(minute.count<2)
        {
            minute = "0"+minute;
        }
        
        cell.date.text=month+"/"+day+"/"+year+" "+hour+":"+minute;
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight/6)
    }
    
    //Sorts and reloads data
    func setUp()
    {
        sortedHistory=savedHistory.allValues.sorted(by: {
            (one, two) -> Bool in
            return (one as! SavedSearch).date > (two as! SavedSearch).date
        }) as! [SavedSearch]
        
        selectedHistory.reloadData();
    }
    @IBAction func backToSearch(_ sender: Any)
    {
        controller?.searchView.isHidden=false;
        self.isHidden=true;
        activeView="Search";
    }
}
