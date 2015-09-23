//
//  StatusMenuController.swift
//  weatherBar
//
//  Created by Mark Remi on 9/22/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, WeatherAPIDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    // Get main system status bar for the OS.
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    var weatherAPI: WeatherAPI!
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        //icon?.setTemplate(true)
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        weatherAPI = WeatherAPI(delegate: self)
        updateWeather()
    }
    
    func updateWeather() {
        weatherAPI.fetchWeather("Charleston, SC") { weather in
//            NSLog(weather.city, weather.conditions, weather.currentTime)
            if let weatherMenuItem = self.statusMenu.itemWithTitle("Weather") {
                weatherMenuItem.title = weather.description
            }
        }
    }
    
    func weatherDidUpdate(weather: Weather) {
        NSLog(weather.description)
    }
    
    @IBAction func updateClicked(sender: NSMenuItem) {
       updateWeather()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}
