//
//  User.swift
//  MyCityMyStoryVersion1.1
//
//  Created by Syrine Dridi on 11/17/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import Foundation

import Firebase

import UIKit

class EntityRequest{
    static let sharedInstance = EntityRequest()
    var Sender : String = ""
    var Receiver : String = ""
    var status : String = ""
   // var birthday: String = ""
    var Date :String = ""
    var lon :String = ""
    var lat :String = ""
    var typerequest :Int = 1

    var daterequest : String = ""

   var Id : String!
    var moreInformation = false
    
    init(){
        
    }
    
    init(Sender:String,Receiver: String) {
        self.Sender = Sender
        self.Receiver = Receiver

    }
    init(Sender:String,Receiver: String,status: String) {
        self.Sender = Sender
        self.Receiver = Receiver
        self.status = status

        
    }
    
    
    init(Sender:String,Receiver: String,status: String,lat: String,lon: String) {
        self.Sender = Sender
        self.Receiver = Receiver
        self.status = status
        self.lat = lat
          self.lon = lon
    }
    
    
    init(Sender:String,Receiver: String,Date: String) {
        self.Sender = Sender
        self.Receiver = Receiver
        self.Date = Date
        
    }
    
    init( snap :FIRDataSnapshot) {
        Id = "\(snap.key)"
        status = snap.childSnapshot(forPath: "status").value as! String

        Sender = snap.childSnapshot(forPath: "Sender").value as! String
        Receiver = snap.childSnapshot(forPath: "Receiver").value as! String
        lat = snap.childSnapshot(forPath: "lat").value as! String
        daterequest = snap.childSnapshot(forPath: "daterequest").value as! String
        typerequest = snap.childSnapshot(forPath: "typerequest").value as! Int

        lon = snap.childSnapshot(forPath: "lon").value as! String

        Date = snap.childSnapshot(forPath: "Date").value as! String

    }
    
    
    
    func toAnyObject() -> Any {
        print("Sender"+Sender)
        
        return [
        //    "Id": ""+Id,
            "status": ""+status,
            "lat": ""+lat,
            "lon": ""+lon,
            "Sender": ""+Sender,
            "typerequest": typerequest,
            "daterequest": ""+daterequest,
            "Receiver": ""+Receiver ,
            "Date": ""+Date

            
            
        ]
    }
}
