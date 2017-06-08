//
//  ViewController.swift
//  MapLocator
//
//  Created by Malek T. on 9/28/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import MapKit
import DateTimePicker
import FirebaseAuth
import Firebase
import SystemConfiguration

import BPStatusBarAlert

import EventKit
import UserNotificationsUI //framework to customize the notification

import UserNotifications


class RequestViewController: UIViewController, UISearchBarDelegate ,MKMapViewDelegate,UNUserNotificationCenterDelegate ,CLLocationManagerDelegate  {
    
    var dates:Date = Date()
    var locationManager: CLLocationManager!
    
    let rootRef = FIRDatabase.database().reference()

    var id:EntityUser = EntityUser();
    //var backendless = Backendless.sharedInstance()
    
    var current = Date()
    
    var eventStore = EKEventStore()
    
    var userss : EntityUser? = EntityUser (idd:"aa",email: "aa")
    var lat2 :Double = 0.0
    var long2: Double = 0.0
    
    
    
    @IBAction func send(_ sender: Any) {
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        
        let picker = DateTimePicker.show(selected: current, minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.todayButtonTitle = "Today"
        picker.completionHandler = { date in
            self.current = date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd/MM/YYYY"
            
        //    let dataStore = self.backendless?.data.of(Requestsi.ofClass())
            self.dates = date

            let req = EntityRequest() ;
            req.Date = "\(date)"
            req.daterequest = "\(Date())"
          //  "\(mealstats.serving)"
            req.lat =   "\(self.pointAnnotation.coordinate.latitude)"
            
            req.lon =  "\(self.pointAnnotation.coordinate.longitude)"
            print( "  hi there \(self.pointAnnotation.coordinate.longitude)")
            
           // req.createdin = formatter.string(from: date)
            
            req.Receiver = (self.id.email as String?)!
           // req.Receiver  = self.id
           // req.Sender = SMNavigationController.users

            req.Sender  =  (SMNavigationController.users?.email as String?)!
            
           req.typerequest  = self.segmentedcontrol.selectedSegmentIndex
            
            req.status  = "0"
            //req.type =
            
            
            
            
            
            
            
          
          
            
            let eventItemRef = self.rootRef.child("requests").childByAutoId()
            
            
            
            eventItemRef.setValue(req.toAnyObject())
            
        //   let result = dataStore?.save(req, fault: &error) as? Requestsi
               // print("Contact has been saved: \(result!.objectId)")
//                BPStatusBarAlert(duration: 0.3, delay: 2, position: .navigationBar) // customize duration, delay and position
//                    .message(message: "Request sent")         // customize message
//                    .messageColor(color: .white)                                // customize message color
//                    .bgColor(color: .blue)                                      // customize view's background color
//                    .completion { print("completion closure will called") }     // customize completion(Did hide alert view)
//                    .show()                                                     // Animation start
            
            let alert = UIAlertController(title: "Guess What", message: "Request Sent", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
                let reminder = EKReminder(eventStore: self.eventStore)
                reminder.title = " Session with \(self.id.email)"
                
                let unitFlags: NSCalendar.Unit = [.hour, .day, .month, .year]
                let calendar = Calendar.current
                let alarm = EKAlarm(absoluteDate: date)
                
                reminder.addAlarm(alarm)
                let components = calendar.dateComponents([.hour, .day, .month, .year], from: date)
                reminder.startDateComponents = components
                reminder.priority = 3
                
                reminder.location = " teacher house "
                reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
                
                
                let content = UNMutableNotificationContent()
                content.title =  "  Nearby Teacher"
                content.subtitle = " SESSION ALERT"
                content.body = " Session with \(self.id.email) is about to start "
                content.sound = UNNotificationSound.default()
                
                //To Present image in notification
                if let path = Bundle.main.path(forResource: "my", ofType: "png") {
                    let url = URL(fileURLWithPath: path)
                    
                    do {
                        let attachment = try UNNotificationAttachment(identifier: "my", url: url, options: nil)
                        content.attachments = [attachment]
                    } catch {
                        print("attachment not found.")
                    }
                }
                
                var elapsed = self.dates.timeIntervalSince(Date())
                
                
                elapsed = elapsed +  90.0
                // Deliver the notification in five seconds.
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: elapsed, repeats: false)
                
                UNUserNotificationCenter.current().delegate = self
                let request = UNNotificationRequest(identifier: "UUID", content: content, trigger: trigger)
                
                
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        
                        print(error?.localizedDescription as Any)
                    }
                }
                
                
                
                do {
                    try self.eventStore.save(reminder, commit: true)
                    // dismiss(animated: true, completion: nil)
                }catch{
                    print("Error creating and saving new reminder : \(error)")
                }
            
           
            
            //      self.item.title = formatter.string(from: date)
        }
        
        
        
        func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
        }
        
        
        
        
        
        
    }
    @IBOutlet weak var send: UIBarButtonItem!
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    
    @IBOutlet var mapView: MKMapView!
    var indicator = UIActivityIndicatorView()
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        indicator.stopAnimating()
        
    }
    
    @IBOutlet weak var segmentedcontrol: UISegmentedControl!
    @IBAction func sitch(_ sender: UISegmentedControl) {
        self.mapView.removeAnnotation(self.pointAnnotation)
        
        
        
        func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
            
            if newState == MKAnnotationViewDragState.ending {
                let ann = view.annotation
                print("annotation dropped at: \(ann!.coordinate.latitude),\(ann!.coordinate.longitude)")
            }
        }
        
        switch segmentedcontrol.selectedSegmentIndex
        {
        case 0:
            self.pointAnnotation = MKPointAnnotation()
            
//            let lat = id.lat as! Double
//            let long =  id.long as! Double
            let lat = id.lat
            let long =  id.long
            
            lat2 = Double(lat)!
            long2 = Double(long)!
            
            
            let centerCoordinate = CLLocationCoordinate2D(latitude: lat2, longitude: long2)
            self.mapView.selectAnnotation(pointAnnotation, animated: true)
            pointAnnotation.coordinate = centerCoordinate
            
            
            self.pointAnnotation.title = id.email
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "myPin")
            pinAnnotationView.isDraggable = false ;
            pinAnnotationView.canShowCallout = false ;
            pinAnnotationView.pinTintColor = .red
            self.mapView.centerCoordinate  = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
            
            
            
        case 1:
            
            let alert = UIAlertController(title: "heyah", message: "Sarch for places And drag the marker to change the session position", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let lat = id.lat 
            let long =  id.long 
            
            lat2 = Double(lat)!
            long2 = Double(long)!
            
            let centerCoordinate = CLLocationCoordinate2D(latitude: lat2, longitude: long2)
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title =  " your position"
            self.pointAnnotation.coordinate = centerCoordinate
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "myPin")
            self.pinAnnotationView.isDraggable=true ;
            self.pinAnnotationView.canShowCallout  = false
            self.pinAnnotationView.pinTintColor = .green
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            self.mapView.selectAnnotation(pointAnnotation, animated: true)
            
            
            
            
            
        default:
            break;
        }
    }
    @IBAction func showSearchBar(_ sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
        
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        for view in views {
            view.isDraggable = true ;
            view.canShowCallout = false
            
        }
        
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
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pointAnnotation = MKPointAnnotation()
        let lat = Double(id.lat)
        let long =  Double(id.long) 
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        self.mapView.selectAnnotation(pointAnnotation, animated: true)
        pointAnnotation.coordinate = centerCoordinate
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(gestureRecognizer:)))
        //self.pointAnnotation.title =  id.getProperty("name") as? String
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "myPin")
        pinAnnotationView.isDraggable = true ;
        pinAnnotationView.canShowCallout = false ;
        self.mapView.centerCoordinate = self.pointAnnotation.coordinate
        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        
        
        //   let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector(("addPin:")))
        
        
        uilgr.minimumPressDuration = 1.0
        //reminder
        
        eventStore.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                if !granted {
                    print("Access to store not granted")
                }
        })
        
        
        self.mapView.addGestureRecognizer(uilgr)
        //IOS 9
        
        // gestureRecognizer.numberOfTouchesRequired = 1
        
        //      mapView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        //self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.coordinate = newCoordinates
        mapView.addAnnotation(pointAnnotation)
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addPin(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        if pointAnnotation != nil {
            pointAnnotation.coordinate = newCoordinates
        }
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.coordinate = newCoordinates
            mapView.addAnnotation(  self.pointAnnotation)
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            self.pointAnnotation = nil
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinTintColor = UIColor.purple
            pinAnnotationView.animatesDrop = true
            
            return pinAnnotationView
        }
        return nil
    }
    
    
    
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == "UUID"{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
    
    
    
    
    
    
}

