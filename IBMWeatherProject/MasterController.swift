//
//  MasterController.swift
//  IBMWeatherProject
//
//  Created by Brian Glatt on 8/3/18.
//  Copyright © 2018 VUII. All rights reserved.
//

//Class used to make certain objects more avalible throughout project

import UIKit
import CoreLocation

var lm : CLLocationManager = CLLocationManager.init();

var locations : NSMutableArray = NSMutableArray.init();
var weather : NSMutableArray = NSMutableArray.init();

var savedHistory : NSMutableDictionary = [:];

var state : String = "Nothing";

var activeView : String = "MainMenu";

var activeLocation : String = "";

var screenWidth : CGFloat = 0.0
var screenHeight : CGFloat = 0.0
var lineScaleX : CGFloat = 0.0
var lineScaleY : CGFloat = 0.0

var keyboardScrollBuffer : CGFloat = 0.0

var controller : ViewController? = nil;

var prefs : UserDefaults = UserDefaults.standard

class MasterController: NSObject
{
    
}
