//
//  Demo2Controller.swift
//  StretchHeaderDemo
//
//  Created by yamaguchi on 2016/03/27.
//  Copyright © 2016年 h.yamaguchi. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreLocation
import MapKit

import Cosmos

class RequestDetailViewControllers: UITableViewController ,CLLocationManagerDelegate ,MKMapViewDelegate {
    var id:EntityUser = EntityUser();
    var req:EntityRequest = EntityRequest();
    var header : MapHeader!
    
    var mylocation : CLLocation = CLLocation()
    var indicator = UIActivityIndicatorView()
    
    var locationManager: CLLocationManager!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
        
        
        //  tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        setupHeaderView()
    }
    
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        indicator.stopAnimating()
        
        determineCurrentLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        mylocation = userLocation
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        
        
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        self.header.imageView.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    func setupHeaderView() {
        
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        
        header = MapHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        
        self.header.imageView.delegate  = self
        
        
        let annotation = MKPointAnnotation()
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: Double (self.id.lat)! , longitude:  Double (self.id.long )!)
        annotation.coordinate = centerCoordinate
        
        
        
        annotation.title = self.id.Firstname
        
        header.imageView.addAnnotation(annotation)
        header.imageView.selectAnnotation(annotation, animated: true)
        // custom
        
        
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.806495, longitude: 10.181532), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude), addressDictionary: nil))
        
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.header.imageView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.header.imageView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        let label = UIOutlinedLabel()
        label.frame = CGRect( x: 10, y: header.frame.size.height - 40, width: header.frame.size.width - 20, height: 40)
        label.textColor = UIColor.white
        label.text = id.Firstname
        label.font = UIFont.boldSystemFont(ofSize: 24)
        header.addSubview(label)
        
        
        tableView.tableHeaderView = header
    }
    
    
    func showRoute(_ response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            self.header.imageView.add(route.polyline,
                                      level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
        }
    }
    // MARK: - ScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        
        if indexPath.row==0
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd/MM/YYYY"
            cell.textLabel?.text = req.daterequest
            cell.detailTextLabel?.text=" Request Date"
            cell.imageView?.image=#imageLiteral(resourceName: "date");
            
        }
        
        
        if indexPath.row==1
        {
            
            let state = Int (req.status)
            if ( state == 0 )
            {
                
                cell.textLabel?.text = "pending"
                
            }
            
            if ( state == 1 )
            {
                
                cell.textLabel?.text = "accepted"
                
            }
            
            if ( state == 2 )
            {
                
                cell.textLabel?.text = "refused"
                
            }
            
            
            cell.imageView?.image=#imageLiteral(resourceName: "accepted");
            
            
            cell.detailTextLabel?.text=" Request stat "
            
        }
        
        
        if indexPath.row==2
        {
            
            let type = req.typerequest
            
            if ( type == 0 )
            {
                
                cell.textLabel?.text = "Teacher's house"
                
            }
            
            if ( type == 1 )
            {
                
                cell.textLabel?.text = "your house"
                
            }
            
            cell.imageView?.image=#imageLiteral(resourceName: "type");
            cell.detailTextLabel?.text=" Session location "
            
        }
        
        if indexPath.row==3
        {
            cell.textLabel?.text = req.Date
            cell.detailTextLabel?.text=" date sent"
            
            cell.imageView?.image=#imageLiteral(resourceName: "date");
            
        }
        
        
        
        
        if indexPath.row==4
        {
            cell.textLabel?.text = (NSString(format: "%@", id.phone) as String)
            cell.detailTextLabel?.text=" Teacher's phone"
            cell.imageView?.image=#imageLiteral(resourceName: "phone");
            
            
            
        }
        
        if indexPath.row==5
        {
            cell.textLabel?.text = (NSString(format: "%@", id.price) as String)
            cell.detailTextLabel?.text="Session price"
            cell.imageView?.image=#imageLiteral(resourceName: "price");
            
            
        }
        
        // cell.textLabel?.text = "index -- \((indexPath as NSIndexPath).row)"
        
        cell.detailTextLabel?.textColor=UIColor.lightGray
        
        cell.imageView?.layer.cornerRadius  = 25
        
        cell.imageView?.layer.masksToBounds = true;
        return cell
    }
    
    
    class CustomTableViewCell: UITableViewCell {
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        // Here you can customize the appearance of your cell
        override func layoutSubviews() {
            super.layoutSubviews()
            // Customize imageView like you need
            self.imageView?.frame = CGRect(x:10,y:0,width :40, height :40)
            self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            // Costomize other elements
            self.textLabel?.frame = CGRect(x:60, y:0, width:  self.frame.width - 45,  height:20)
            self.detailTextLabel?.frame = CGRect(x:60, y:20,  width :self.frame.width - 45, height: 15)
        }
    }
    
    
    
    
    class UIOutlinedLabel: UILabel {
        
        var outlineWidth: CGFloat = 1
        var outlineColor: UIColor = UIColor.black
        
        override func drawText(in rect: CGRect) {
            
            let strokeTextAttributes = [
                NSStrokeColorAttributeName : outlineColor,
                NSStrokeWidthAttributeName : -4 * outlineWidth,
                ] as [String : Any]
            
            self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
            super.drawText(in: rect)
        }
        //  self.view.frame.
    }
    
    
    
    @nonobjc func locationManager(_ manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // let location = locations.last as! CLLocation
        
        //  let center = CLLocationCoordinate2D(latitude: self.id.lat, longitude: self.id.lon)
        // let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
        
        
        header.imageView.showsUserLocation = true
        
        //  header.imageView.setRegion(region, animated: true)
    }
    
    open func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        // zoomToUserLocation(mapView.userLocation, minLatitude: kOpenShutterLatitudeMinus, animated: true)
        
        // zoomToUserLocation(mapView.userLocation, minLatitude: kCloseShutterLatitudeMinus, animated: true)
        
        
    }
    
    
    func zoomToUserLocation(_ userLocation: MKUserLocation, minLatitude: Double, animated: Bool) {
        if (userLocation.isEqual(nil)) {
            return
        }
        let usr = MKUserLocation( )
        
        
        
        var loc = userLocation.coordinate
        self.header.imageView.showsUserLocation = true;
        loc.latitude = loc.latitude - minLatitude
        self.header.imageView.addAnnotation(usr)
        
        var region = MKCoordinateRegion.init(center: loc, span: MKCoordinateSpanMake(7,7))
        region = self.header.imageView.regionThatFits(region)
        self.header.imageView.setRegion(region, animated: animated)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //print(view.annotation?.title!);
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = false
            
            let rightButton: AnyObject! = UIButton(type: .detailDisclosure)
            
            
            pinView!.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}

