//
//  AppDelegate.swift
//  CNC_Mill
//
//  Created by Ruedi Heimlicher on 30.05.2020.
//  Copyright © 2020 Ruedi Heimlicher. All rights reserved.
//

import Cocoa
import CoreFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



   func applicationDidFinishLaunching(_ aNotification: Notification) 
   {
      // Insert code here to initialize your application
   
   }
   func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
      print("applicationWillTerminate")
   
   }

   func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply
      
   {
      print("applicationShouldTerminate") 
      let nc = NotificationCenter.default
      /*
       nc.post(name:Notification.Name(rawValue:"beenden"),
       object: nil,
       userInfo: nil)
       */
      return .terminateNow
   }

}

