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

class EntityMessage{
    static let sharedInstance = EntityMessage()
    var Sender : String = ""
    var Receiver : String = ""
    var status : String = ""
    // var birthday: String = ""
    var Date :String = ""
    var message : String = ""
    var Id : String!

    var moreInformation = false
    
    init(){
        
    }
    
    init(Sender:String,Receiver: String,message: String) {
        self.Sender = Sender
        self.Receiver = Receiver
        self.message = message

        
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
    
    init(Sender:String,Receiver: String,status: String,message: String) {
        self.Sender = Sender
        self.Receiver = Receiver
        self.status = status
        self.message = message

        
        
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
        message = snap.childSnapshot(forPath: "message").value as! String

        Date = snap.childSnapshot(forPath: "Date").value as! String
        
    }
    
    
    
    func toAnyObject() -> Any {
        print("Sender"+Sender)
        
        return [
            //    "Id": ""+Id,
            "status": ""+status,
            "message": ""+message,

            "Sender": ""+Sender,
            "Receiver": ""+Receiver ,
            "Date": ""+Date
            
            
            
        ]
    }
}
