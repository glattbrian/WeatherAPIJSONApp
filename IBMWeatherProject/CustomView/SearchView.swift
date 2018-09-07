//
//  SearchView.swift
//  IBMWeatherProject
//
//  Created by Brian Glatt on 8/4/18.
//  Copyright © 2018 VUII. All rights reserved.
//

/*
 Contains and controls search bar and table view for history
 */

import UIKit

class SearchView : UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    var filteredArray : [SavedSearch] = [];
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return filteredArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        cell.textLabel?.text=filteredArray[indexPath.item].text
        
        return cell;
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //Sorts by date to handle exteral history
        let sortedData=savedHistory.allValues.sorted(by: {
            (one, two) -> Bool in
            return (one as! SavedSearch).date > (two as! SavedSearch).date
        })
        
        //Filter data based on search bar contents
        filteredArray = sortedData.filter(
            {
                (text) ->
                Bool in
                //Only searched that yield results will appear in autocomplete
                if(!(text as! SavedSearch).good)
                {
                    return false;
                }
                let criteria = ((text as! SavedSearch).text as NSString).range(of: searchText, options: NSString.CompareOptions.caseInsensitive);
                return criteria.location != NSNotFound
        }) as! [SavedSearch]
        tableView.reloadData();
    }
    
    //Preforms search based on input
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder();
        controller?.getIDsFromName(name: searchBar.text!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        searchBar.text=tableView.cellForRow(at: indexPath)?.textLabel?.text;
    }
    
    @IBAction func backToMain(_ sender: Any)
    {
        controller?.mainView.isHidden=false;
        self.isHidden=true;
        activeView="MainMenu";
        searchBar.resignFirstResponder();
    }
    
    @IBAction func toHistory(_ sender: Any)
    {
        controller?.historyView.isHidden=false;
        self.isHidden=true;
        activeView="History";
        controller?.historyView.setUp();
        searchBar.resignFirstResponder();
    }
}
