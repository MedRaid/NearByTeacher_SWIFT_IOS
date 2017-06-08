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

class EntityUser {
    static let sharedInstance = EntityUser()
    var  Firstname : String = ""
    var Lastname : String = ""
    var birthday: String = ""
    var city :String = ""
    var  idd : String = ""

    var country :String = ""
    var phone : String = ""
    var sexe:String = ""
    var urlImage:Any = Any.self
    //*******************/
      var email :String = ""
    var price :String = ""
    var nrating :Double = 1
    var rating :Double = 2
    var rated :String = ""

    var spec :String = ""
    var ts :String = ""
    var long :String = ""
    var lat :String = ""
    /***********************/
    var image: UIImage?
    var moreInformation = false
    
    init(){
        
    }
    
    init(email:String,Firstname: String, Lastname: String, city: String ,country :String,sexe :String,phone : String,birthday : String,urlImage : Any,ts : String) {
        self.Lastname = Lastname
        self.Firstname = Firstname
        self.birthday = birthday
        // self.addedByUser = addedByUser"phone": ""+phone,
        self.city = city
        self.country = country
        self.sexe = sexe
        self.phone=phone
        self.urlImage = urlImage
    }
    init(email:String,Firstname: String, Lastname: String, city: String ,country :String,sexe :String,phone : String,birthday : String ) {
        self.Lastname = Lastname
        self.Firstname = Firstname
        self.birthday = birthday
        // self.addedByUser = addedByUser"phone": ""+phone,
        self.city = city
        self.country = country
        self.sexe = sexe
        self.phone=phone
    }
    

    
    init( snap :FIRDataSnapshot) {
        
Lastname = snap.childSnapshot(forPath: "lastname").value as! String
        Firstname = snap.childSnapshot(forPath: "firstname").value as! String
        country = snap.childSnapshot(forPath: "country").value as! String
        city = snap.childSnapshot(forPath: "city").value as! String
        phone = snap.childSnapshot(forPath: "phone").value as! String
        email = snap.childSnapshot(forPath: "email").value as! String
/******/
        price = snap.childSnapshot(forPath: "price").value as! String
        nrating = snap.childSnapshot(forPath: "nrating").value as! Double
        rating = snap.childSnapshot(forPath: "rating").value as! Double
        spec = snap.childSnapshot(forPath: "spec").value as! String
        ts = snap.childSnapshot(forPath: "ts").value as! String

        long = snap.childSnapshot(forPath: "long").value as! String
        lat = snap.childSnapshot(forPath: "lat").value as! String

        
/********/
        sexe = snap.childSnapshot(forPath: "sexe").value as! String
        birthday = snap.childSnapshot(forPath: "birthday").value as! String
        urlImage = snap.childSnapshot(forPath: "urlImageUser").value as Any
    }
    
    init (phone:String,email:String,ts:String){
    self.phone=phone
        self.email=email
          self.ts=ts
        

    }
    
    init (idd:String,email:String){
        self.idd=idd
        self.email=email
      
        
        
    }
    
    init (phone:String,email:String,price:String,nrating:Double,rating:Double,spec:String,lat:String,long:String,Firstname:String,ts:String,urlImage:Any){
        self.phone=phone
        self.email=email
        self.price=price
        self.nrating=nrating
        self.rating=rating
        self.spec=spec
        self.lat=lat
        self.long=long
        self.Firstname=Firstname
        self.ts=ts
        self.urlImage = urlImage
        
        
    }
    
    init (phone:String,email:String,ts:String,lat:String,long:String,Firstname:String,urlImage:Any){
        self.phone=phone
        self.email=email
        self.ts=ts
          self.lat=lat
          self.long=long
        self.Firstname=Firstname
        self.urlImage=urlImage
        
    }
    
    init (phone:String,email:String,ts:String,urlImage:Any){
        self.phone=phone
        self.email=email
        self.ts=ts
        self.urlImage=urlImage
        
    }

    init (phone:String,ts:String,urlImage:Any){
        self.phone=phone
        self.ts=ts
        self.urlImage=urlImage
        
    }
    
    
    init (spec:String,price:String){
        self.spec=spec
        self.price=price
        
    }
    
    
    
    
    init (phone:String,email:String,price:String,nrating:Double,rating:Double,spec:String,ts:String){
        self.phone=phone
        self.email=email
        self.price=price
        self.nrating=nrating
        self.rating=rating
        self.spec=spec
        
        self.ts=ts
        
    }
    
    
    
    init (phone:String,email:String,ts:String,price:String,spec:String){
        self.phone=phone
        self.email=email
        self.price=price
 
        self.spec=spec
        
        self.ts=ts
        
    }
    
    
    init (phone:String,email:String,ts:String,price:String,spec:String,long:String,lat:String){
        self.phone=phone
        self.email=email
        self.price=price
        
        self.spec=spec
        
        self.ts=ts
        
        self.long=long
        self.lat=lat

    }
    
    
    func toAnyObjectnoImg() -> Any {
        print("lastname"+Lastname)
        
        return [
            "lastname": ""+Lastname,
            "firstname": ""+Firstname ,
            "country": ""+country,
            "city" : ""+city,
            "phone": ""+phone,
            "price": ""+price,
            "nrating": nrating,
            "rating": rating,
            "spec": ""+spec,
            "ts": ""+ts,
            "email": ""+email,
            "sexe": ""+sexe,
            "birthday": ""+birthday
            
            
        ]
    }
    
    
    func toAnyObject() -> Any {
        print("lastname"+Lastname)
        
        return [
            "idd": ""+idd,

            "lastname": ""+Lastname,
            "firstname": ""+Firstname ,
            "country": ""+country,
            "city" : ""+city,
            "phone": ""+phone,
            "price": ""+price,
            "nrating": nrating,
            "rating": rating,
             "rated": ""+rated,
            "spec": ""+spec,
            "ts": ""+ts,
            "email": ""+email,
            "sexe": ""+sexe,
            "long": ""+long,
            "lat": ""+lat,
            "birthday": ""+birthday,
            "urlImageUser": urlImage
            
            
        ]
    }
}
