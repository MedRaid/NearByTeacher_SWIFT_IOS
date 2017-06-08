//
//  MapAnnotations.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 3/20/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//

import MapKit

class MapAnnotations: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var pinColor: UIColor


    init(title:String,subtitle:String,coordinate:CLLocationCoordinate2D,pinColor:UIColor){
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
        self.pinColor = pinColor

    }
    
    init(pinColor: UIColor,coordinate:CLLocationCoordinate2D) {
        self.pinColor = pinColor
        self.coordinate = coordinate

    }

}

