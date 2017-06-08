//
//  VFParallaxController.swift
//  VFParallaxController
//
//  Created by Veri Ferdiansyah on 09/01/2016.
//  Copyright (c) 2016 Veri Ferdiansyah. All rights reserved.
//

import MapKit
import UIKit
import SDWebImage
import MobileCoreServices
import FirebaseAuth
import Firebase
import Kingfisher
import SystemConfiguration


let kScreenHeightWithoutStatusBar = UIScreen.main.bounds.size.height - 20
let kScreenWidth = UIScreen.main.bounds.size.width
let kStatusBarHeight = 20
let kYDownTableView = kScreenHeightWithoutStatusBar - 40
let kDefaultHeaderHeight = 100.0
let kMinHeaderHeight = 10.0
let kDefaultYOffset = (UIScreen.main.bounds.size.height == 480.0) ? -200.0 : -250.0
let kFullYOffset = -200.0
let kMinYOffsetToReach = -30
let kOpenShutterLatitudeMinus = 0.005
let kCloseShutterLatitudeMinus = 0.018

open class VFParallaxController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UIGestureRecognizerDelegate , CLLocationManagerDelegate {
    var tableView: UITableView!
    var mapView: MKMapView!
    var mapViewTappedGesture: UITapGestureRecognizer!
    var tableViewTappedGesture: UITapGestureRecognizer!
    var mapHeight: Double = 1000.0
    var isShutterOpened: Bool = false
    var isMapDisplayed: Bool = false
    var teachers:  [EntityUser] = [] ;
    var Annotations: [MyPointAnnotation]  = [] ;
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var locationManager: CLLocationManager!
    
    static var users = [EntityUser]()

    
    var indicator = UIActivityIndicatorView()
    
    override open func viewWillAppear(_ animated: Bool) {
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        indicator.stopAnimating()
        let alert = UIAlertController(title: "How To Use", message: "Swipe on the desired teacher in order to access his profile and to send request", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
     
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        setupTableView()
        setupMapView()

        openShutter()
        
        self.tableView.rowHeight = 44.0
        
        
        //  items = [EntityUser]()
        let _:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        if ( rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!) != nil ){
            
            
            _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "ts").queryEqual(toValue: "t").observeSingleEvent(of: .value, with: { (snapshot) in
                
                //                let ref = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "lat").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        self.teachers.append(EntityUser(snap: snap))
                        
                        
                        
                        //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                    }
                    
                    print("aaaaaaaaaaaaaaaaa")
                    
                    print(self.teachers.count-1)
                     }

          
                    if (CLLocationManager.locationServicesEnabled())
                    {
                        self.locationManager = CLLocationManager()
                        self.locationManager.delegate = self
                        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        self.locationManager.requestWhenInUseAuthorization()
                        self.locationManager.startUpdatingLocation()
                    }
                    
                    //print(teacher.getProperty("long"))
                    
                    // teachers.append(teacher);
                if (self.teachers.count-1 > 0){
                        for i in 0...self.teachers.count-1 {
            
                        print(self.teachers[i].email)
                        
                            VFParallaxController.users = [self.teachers[i]]
                            print("OOOOOOOOOOOOOOOO")
                            print(VFParallaxController.users.count)

                        
                        
                        let annotation = MyPointAnnotation(pinColor: .green)
                        
                        let long = Double(self.teachers[i].long)
                        let lat = Double(self.teachers[i].lat)
                        
                        
                        let centerCoordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                        annotation.coordinate = centerCoordinate
                        annotation.pinTintColor = .blue
                        //   annotation.pinann
                        //annotation.perform(aSelector: Selector!)
                        
                        
                        
                        annotation.title = self.teachers[i].Firstname as String?
                        
                        self.mapView.addAnnotation(annotation)
                        
                        self.Annotations.append(annotation)
                }
            }
                else{
                let alert = UIAlertController(title: "Check", message: "No Teatchers Available at the moment", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
                })                }
              self.tableView.reloadData()


                }
            )
            }

                //            })
      
        
        }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 20, width: CGFloat(kScreenWidth), height: CGFloat(kScreenHeightWithoutStatusBar)))
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: CGFloat(kDefaultHeaderHeight)))
        tableView.backgroundColor = UIColor.clear
        
        mapViewTappedGesture = UITapGestureRecognizer.init(target: self, action: #selector(mapViewTappedHandler))
        tableViewTappedGesture = UITapGestureRecognizer.init(target: self, action: #selector(tableViewTappedHandler))
        tableViewTappedGesture.delegate = self
        
        tableView.tableHeaderView?.addGestureRecognizer(mapViewTappedGesture)
        tableView.addGestureRecognizer(tableViewTappedGesture)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
       
         view.addSubview(tableView)
      

    
    
    
    }
    
    func setupMapView() {
        mapView = MKMapView.init(frame: CGRect(x: 0, y: CGFloat(kDefaultYOffset), width: CGFloat(kScreenWidth), height: CGFloat(kScreenHeightWithoutStatusBar)))
        mapView.showsUserLocation = true
        mapView.delegate = self
        self.view.insertSubview(mapView, belowSubview: tableView)
    }
    
    // MARK: - Internal Methods
    
    @objc func mapViewTappedHandler(_ gesture: UIGestureRecognizer) -> Void {
        if (!isShutterOpened) {
            openShutter()
        }
    }
    
    @objc func tableViewTappedHandler(_ gesture: UIGestureRecognizer) -> Void {
        if (isShutterOpened) {
            closeShutter()
        }
    }
    
    func openShutter() {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
            self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CGFloat(kMinHeaderHeight)))
            self.tableView.frame = CGRect(x: 0, y: CGFloat(kYDownTableView), width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
            self.tableView.tableHeaderView?.backgroundColor =  UIColor.white.withAlphaComponent(0.75)
            self.mapView.frame = CGRect(x: 0, y: CGFloat(kFullYOffset), width: self.mapView.frame.size.width, height: CGFloat(self.mapHeight))
        }) { (finished) in
            self.tableView.allowsSelection = false
            self.tableView.isScrollEnabled = false
            self.isShutterOpened = true
            
        }
        
    }
    
    func closeShutter() {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
            self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: CGFloat(kDefaultYOffset), width: self.view.frame.size.width, height: CGFloat(kDefaultHeaderHeight)))
            self.tableView.frame = CGRect(x: 0, y: CGFloat(kStatusBarHeight), width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
            self.mapView.frame = CGRect(x: 0, y: CGFloat(kDefaultYOffset), width: self.mapView.frame.size.width, height: CGFloat(kScreenHeightWithoutStatusBar))
        }) { (finished) in
            self.tableView.allowsSelection = true
            self.tableView.isScrollEnabled = true
            self.isShutterOpened = false
            
            
        }
    }
    
    func zoomToUserLocation(_ userLocation: MKUserLocation, minLatitude: Double, animated: Bool) {
        
        
        if (userLocation.isEqual(nil)) {
            return
        }
        let usr = MKUserLocation( )
        
        
        
        var loc = userLocation.coordinate
        self.mapView.showsUserLocation = true;
        loc.latitude = loc.latitude - minLatitude
        self.mapView.addAnnotation(usr)
        
        var region = MKCoordinateRegion.init(center: loc, span: MKCoordinateSpanMake(6,8))
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: animated)
    }
    
    // MARK: - UITableViewDelegate Methods
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        var mapViewHeaderFrame = mapView.frame
        
        if (scrollOffset < 0) {
            mapViewHeaderFrame.origin.y = CGFloat(kDefaultYOffset) - (scrollOffset / 2)
        } else {
            mapViewHeaderFrame.origin.y = CGFloat(kDefaultYOffset) - scrollOffset
        }
        
        mapView.frame = mapViewHeaderFrame
        
        if (tableView.contentOffset.y < CGFloat(kMinYOffsetToReach)) {
            if (!isMapDisplayed) {
                isMapDisplayed = true
            }
        } else {
            if (isMapDisplayed) {
                isMapDisplayed = false
            }
        }
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (isMapDisplayed) {
            openShutter()
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hahahahahahahhaha")
        print(VFParallaxController.users.count)
        return (teachers.count)
        
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.imageView!.layer.cornerRadius = 20
        
        if (indexPath.row == 0) {
            if (cell.isEqual(nil)) {
                cell = UITableViewCell.init(style: UITableViewCellStyle.value2, reuseIdentifier: "firstCell") as! VFParallaxController.CustomTableViewCell
                
                let cellBounds = cell.layer.bounds
                let shadowFrame = CGRect(x: cellBounds.origin.x, y: cellBounds.origin.y, width: tableView.frame.size.width, height: 10.0)
                let shadowPath = UIBezierPath.init(rect: shadowFrame).cgPath
                
                cell.layer.shadowPath = shadowPath
                cell.layer.shadowOffset = CGSize(width: -2, height: -2)
                cell.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOpacity = 0.50
                cell.layer.opacity = 0.50
            }
        } else {
            if (cell.isEqual(nil)) {
                cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "otherCell") as! VFParallaxController.CustomTableViewCell
            }
        }
        let tteacher = self.teachers[indexPath.row]
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.textLabel?.text = " "+tteacher.Firstname as String?
       // cell.imageView?.sd_setImage(with: URL(string: tteacher.urlImage as! String), placeholder: UIImage(named: "face2.png"))
        
         cell.imageView?.sd_setImage(with: URL(string: tteacher.urlImage as! String), placeholderImage: UIImage(named: "teat"))
       
//        
//        let url = URL(string: tteacher.urlImage as! String)
//        cell.imageView?.kf.setImage(with: url)
//        
//        
        
        cell.detailTextLabel?.textColor=UIColor.white
        cell.detailTextLabel?.tintColor=UIColor.white
        
        cell.detailTextLabel?.text = "Email: "+tteacher.email as String?
        
        cell.imageView?.frame = CGRect(x:0,y:0,width:100, height:200)

        return cell
    }
    var cellColors = ["80e5ff","99ebff","b3f0ff","ccf5ff","e6faff","ffffff"]

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let totalRow = tableView.numberOfRows(inSection: indexPath.section)
        cell.contentView.backgroundColor = UIColor(hexString: cellColors[indexPath.row % cellColors.count])

        if (indexPath.row == totalRow - 1) {
            let cellsHeight = CGFloat(totalRow) * cell.frame.size.height
            let tableHeight = tableView.frame.size.height - (tableView.tableHeaderView?.frame.size.height)!
            
            if ((cellsHeight - tableView.frame.origin.y) < tableHeight) {
                let footerHeight = tableHeight - cellsHeight
                tableView.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGFloat(kScreenWidth), height: footerHeight))
                tableView.tableFooterView?.backgroundColor = UIColor.white
            }

        }

    }
    
    // MARK: - MKMapViewDelegate Methods
    
    open func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if (isShutterOpened) {
            zoomToUserLocation(mapView.userLocation, minLatitude: kOpenShutterLatitudeMinus, animated: true)
        } else {
            zoomToUserLocation(mapView.userLocation, minLatitude: kCloseShutterLatitudeMinus, animated: true)
        }
        
    }
    
    
    
    public func mapView(_ viewFormapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.pinTintColor = UIColor.blue
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    
    // MARK: - UIGestureRecognizerDelegate Methods
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (gestureRecognizer == tableViewTappedGesture) {
            return isShutterOpened
        }
        return true
    }
    
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        
        self.mapView.selectAnnotation(self.Annotations [indexPath.row], animated: true);
        
        self.Annotations [indexPath.row].pinTintColor = .green
        
        //closeShutter()
    }
    
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotationView = view  as! MKPinAnnotationView
        
        annotationView.pinTintColor = .red
        mapView.selectAnnotation(view.annotation!, animated: true)
        
        
        
        openShutter()
        
        //performSegueWithIdentifier("locationInfoSegue", sender: self)
    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        
        
    }
    
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       let svc : RequestViewController = segue.destination as! RequestViewController
        
        svc.id = sender as! EntityUser
        
        
        
    }
    
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let tteacher = self.teachers[editActionsForRowAt.row]
        
        let favorite = UITableViewRowAction(style: .normal, title: "Profile") { action, index in
            
          // print(tteacher.objectId);
           let vc = TeacherController()
            vc.id=tteacher

            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
           self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Request") { action, index in
            print("kkkkkkkkkkkkk")
            print(tteacher.lat)
            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
         self.performSegue(withIdentifier: "requests", sender: tteacher)
        }
        share.backgroundColor = .blue
        
        return [share, favorite]
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
    
    
    class MyPointAnnotation : MKPointAnnotation {
        var pinTintColor: UIColor?
        
        init(pinColor: UIColor) {
            self.pinTintColor = pinColor
            super.init()
        }
    }
    
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


