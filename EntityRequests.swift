//
//  EntityRequests.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 4/26/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//

import Foundation
import Firebase

class EntityRequests : NSObject {
    
    var Id : String?
    var senderemail : String?
    var receiveremail: String?
    var Sender : EntityUser?
    var  Receiver : EntityUser?
    var createdin : String = ""
    var  lat : Double = 0.0
    var  lon : Double = 0.0
    var typerequest : Int = 0
    var state : Int = 0
    var daterequest : Date?
    
    
    override init(){}
    
    init( snap :FIRDataSnapshot) {
        Id = "\(snap.key)"
        state = snap.childSnapshot(forPath: "status").value as! Int
        
        Sender = snap.childSnapshot(forPath: "Sender").value as! EntityUser
        Receiver = snap.childSnapshot(forPath: "Receiver").value as! EntityUser
        daterequest = snap.childSnapshot(forPath: "daterequest").value as! Date
        createdin = snap.childSnapshot(forPath: "createdin").value as! String
        senderemail = snap.childSnapshot(forPath: "senderemail").value as! String
        receiveremail = snap.childSnapshot(forPath: "receiveremail").value as! String
        
        lat = snap.childSnapshot(forPath: "lat").value as! Double
        
        lon = snap.childSnapshot(forPath: "lon").value as! Double
        typerequest = snap.childSnapshot(forPath: "typerequest").value as! Int


        
        
    }
    

    
    
    
    
    
    
    
    
    func toAnyObject() -> Any {
        
        return [
                //"Id": ""+Id,
            "status": state,
            
            "Sender": Sender!,
            "Receiver": Receiver! ,
            "receiveremail": receiveremail! ,

            "senderemail": senderemail! ,

            "daterequest" : daterequest!,
            "lat" : lat,
            "lon" : lon,
            "typerequest" : typerequest,
            "createdin" : createdin
            
            
            
        ]
    }
    
}
