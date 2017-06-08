//
//  SMNavigationController.swift
//  LNSideMenuEffect
//
//  Created by Luan Nguyen on 6/30/16.
//  Copyright © 2016 Luan Nguyen. All rights reserved.
//
import UIKit
import MobileCoreServices
import FirebaseAuth
import Firebase
import LNSideMenu
import FBSDKLoginKit
import SystemConfiguration


class SMNavigationController: LNSideMenuNavigationController {
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var stat:String!=""
    static var users : EntityUser!
    var indicator = UIActivityIndicatorView()

    var email : String = "a"
    var phone : String = ""
    
    let userss : EntityUser? = EntityUser (idd:"aa",email: "aa")
    fileprivate var items:[String]?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lista" {
            let _: UITabBarController = segue.destination as! UITabBarController
            
            
        }
//        else
//        {
//            
//
//          let vcs = Demo2Controller()
//       
//           // vcs.id=SMNavigationController.users
//            
//            vcs.id = sender as! EntityUser
//
//        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        indicator.stopAnimating()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required at first time running the app to load images and videos ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        
        
        
    
        // Do any additional setup after loading the view.
        // Using default side menu
        items = ["Profile","Enrollments","searchs","Map","Requests","Messages","SignOut"]
        initialSideMenu(.left)
        // Custom side menu
        //    initialCustomMenu(pos: .right)
        
        if ( rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!) != nil ){
            
            
            rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
                
                
                self.userss?.Firstname = snapshot.childSnapshot(forPath: "firstname").value as! String

                self.userss?.email = snapshot.childSnapshot(forPath: "email").value as! String
                print("ahhla")
                self.userss?.idd = (FIRAuth.auth()?.currentUser?.uid)!
                print(self.userss?.email)
                self.userss?.urlImage = snapshot.childSnapshot(forPath: "urlImageUser").value as! String

                self.userss?.long = snapshot.childSnapshot(forPath: "long").value as! String
                self.userss?.lat = snapshot.childSnapshot(forPath: "lat").value as! String

                self.userss?.ts = snapshot.childSnapshot(forPath: "ts").value as! String
                self.userss?.price = snapshot.childSnapshot(forPath: "price").value as! String

                self.userss?.phone = snapshot.childSnapshot(forPath: "phone").value as! String
                self.userss?.spec = snapshot.childSnapshot(forPath: "spec").value as! String
                
                self.userss?.rated = snapshot.childSnapshot(forPath: "rated").value as! String
                UserDefaults(suiteName: "group.NearByTeachers")!.set(self.userss?.Firstname, forKey: "myname")
                print("\(UserDefaults(suiteName: "group.NearByTeachers")!.value(forKey: "myname")!)"+"emmmmmmmmail")
                
                
            })
            
            //  self.userss?.email = self.email
            
            
        }
        else {
        print("null el roof")
        }
        
        SMNavigationController.users = userss
        
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initialSideMenu(_ position: Position) {
        sideMenu = LNSideMenu(sourceView: view, menuPosition: position, items: items!)
        sideMenu?.menuViewController?.menuBgColor = UIColor.darkGray.withAlphaComponent(0.85)
        sideMenu?.delegate = self
        sideMenu?.underNavigationBar = true
        view.bringSubview(toFront: navigationBar)
        
   
    }
    
    fileprivate func initialCustomMenu(pos position: Position) {
        
    }
    
    
    
    fileprivate func setContentVC(_ index: Int) {
        
        
        print("Did select item at index: \(index)")
        
        if index==0{
            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
            
            
            if ( rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!) != nil ){
                
                
                rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
                    self.stat = snapshot.childSnapshot(forPath: "ts").value as! String
                    
                    
                    
                    
                    
                 
                    //print(self.stat)
                    if (self.stat=="s")
                    {
                        let vc = StudentController()
                        vc.id=SMNavigationController.users
                        
                        self.pushViewController(vc, animated: true)                    }
//
                    else if (self.stat=="t")
                    {

                        let vc = TeacherController()
                        vc.id=SMNavigationController.users
                        
                        self.pushViewController(vc, animated: true)
                    }
                    
                })
                
            }

        }
        
        
        if index==1{
            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
            print("zgal3iiiiiiiiii")
            print(SMNavigationController.users.ts)
            
            if (SMNavigationController.users.ts == "s")
                
            {  let vc = MyTeachersViewController()
                
                self.pushViewController(vc, animated: true)
            
            }
                
            else
            {
                performSegue(withIdentifier: "myteachers", sender: self )
            }
            
            
            
            
            
            
        }
        
        

        
        if index==2{
            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
            performSegue(withIdentifier: "search", sender: self )
            
        }
        
        
        
        
        if index==3{
            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
            
            //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "VFParallaxController") as! VFParallaxController
            //   self.navigationController?.present(vc, animated: true, completion: nil)
            
            performSegue(withIdentifier: "LeftMenuTableViewController", sender: self)
            
            print(1)
        }
        
        
       
        
        if index==4{
            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
            print("zgal3iiiiiiiiii")
            print(SMNavigationController.users.ts)
            
            if (SMNavigationController.users.ts == "s")
            
            {  let vc = MyRequestViewController()
            
                self.pushViewController(vc, animated: true)}
            
           else
            {
                performSegue(withIdentifier: "lista", sender: self )
            }

        }
        if index==5{
            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
            self.performSegue(withIdentifier: "TeatchersMsg", sender: self)
            
        }
        
        
        
        if index==6{
            if ConnectionCheck.isConnectedToNetwork() { }
            else{
                let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })                }
            print("signout")
            
            let manager = FBSDKLoginManager()
            manager.logOut()
            
            self.performSegue(withIdentifier: "signOut", sender: self)

        }
        
        
        
        
        
        if index==8{
            
           
            
        }
        
//        if index==0{
//            let aboutNav = UINavigationController()
//            
//            // Initialise the RFAboutView:
//            
//            let aboutView = RFAboutViewController(appName: "akram hamdi", appVersion: "", appBuild: nil, contactEmail: "akram@example.com", contactEmailTitle: "Contact ", websiteURL: URL(string: "2328482"), websiteURLTitle: "Pone nimber", pubYear: "2017")
//            
//            // Set some additional options:
//            
//            aboutView.headerBackgroundColor = UIColor.black
//            aboutView.headerTextColor = UIColor.white
//            aboutView.blurStyle = .dark
//            
//            let imageURL = URL(string: "http://student-web.unizd.hr/~vjurinjak14/English-Teacher.jpg")
//            var image: UIImage?
//            if let url = imageURL {
//                //All network operations has to run on different thread(not on main thread).
//                DispatchQueue.global(qos: .userInitiated).async {
//                    let imageData = NSData(contentsOf: url)
//                    //All UI operations has to run on main thread.
//                    DispatchQueue.main.async {
//                        if imageData != nil {
//                            image = UIImage(data: imageData as! Data)
//                            aboutView.headerBackgroundImage  = image
//                            
//                        } else {
//                            image = nil
//                        }
//                    }
//                }
//            }
//            
//            
//            
//            // Add an additional button:
//            aboutView.addAdditionalButton("Grade", content: "")
//            
//            // Add the aboutView to the NavigationController:
//            aboutNav.setViewControllers([aboutView], animated: true)
//            
//            // Present the navigation controller:
//            self.present(aboutNav, animated: true, completion: nil)
//        }
        
        
        
        
    }
}

extension SMNavigationController: LNSideMenuDelegate {
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    func didSelectItemAtIndex(_ index: Int) {
        setContentVC(index)
    }
}

//extension SMNavigationController: LeftMenuDelegate {
//    func didSelectItemAtIndex(index idx: Int) {
//        sideMenu?.toggleMenu() { [unowned self] _ in
//            self.setContentVC(idx)
//        }
//    }
//}

