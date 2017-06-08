//
//  hisprofileController.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 4/11/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//

import UIKit
import FirebaseAuth
import  FirebaseDatabase
import MobileCoreServices
import FirebaseAuth
import Firebase
import SystemConfiguration

import Kingfisher
class hisprofileController: UIViewController {
    var items : [EntityUser] = [EntityUser] ()
    var ems : String = "a"
    var emeli : String = "a"
    var feedEmail : String = "a"

    var valeur : String = "a"

    var tel : String = "a"
    var imgs : String = "a"

    
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var em: UILabel!
    @IBOutlet var tal: UILabel!
    @IBOutlet var feed: UITextField!
    var emails : String = "aaaaa"

    var indicator = UIActivityIndicatorView()
    
    
  
    
    
    @IBAction func toMessage(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toMessages", sender: valeur)

        
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
    
    
    
    @IBAction func GoFeeds(_ sender: Any) {
        self.performSegue(withIdentifier: "Feeds", sender: feedEmail)

        
        
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
        if ( rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!) != nil ){
            
            
            rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
                
                self.emeli = snapshot.childSnapshot(forPath: "email").value as! String
          
            })
            
            //  self.userss?.email = self.email
            
            
        }

        
        
        
        
        
        
        
        
        _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: emails).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.items.append(EntityUser(snap: snap))
                 //   self.ems = snapshot.childSnapshot(forPath: "email").value as! String
                   // self.tel = snapshot.childSnapshot(forPath: "phone").value as! String

               
                    //                    let  alert = UIAlertController(title: "got", message: self.items[i].email, preferredStyle: UIAlertControllerStyle.alert)
                    //                    // add an action (button)
                    //                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    //                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    //
                    //
                    //                    // show the alert
                    //                    self.present(alert, animated: true, completion: nil)
 
                    
                    
                    
                
                    
                }
                //
                    if (self.items.count > 0){                for i in 0...self.items.count-1 {
                    print("zzzzzzzzzzz")
                    //print(hismail)
                    self.ems = self.items[i].Firstname
                    self.tel = self.items[i].phone
                    self.imgs = self.items[i].urlImage as! String
                        self.valeur = self.items[i].email
                    
                    let url = URL(string: self.imgs)
                    self.photoImage.kf.setImage(with: url)
                    
                    
                    
                    self.em.text = self.ems
                    self.feedEmail = self.ems
                    self.tal.text = self.tel
                    print(self.items[i].email)
                    print("zzzzzzzzz")
                    
                }
                }
            }
        })
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Feeds" {
            let svc : FeedBacksController = segue.destination as! FeedBacksController
            
            svc.self.feedEmail = sender as! String!
            
        }
    }
    
    
    
//sEND Request
    
    @IBAction func SendRequest(_ sender: Any) {
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        let userItem = EntityRequest(Sender: self.emeli,
                                  Receiver: self.ems,
                                  status: "0")       // 3
        //   ts: ts!)       // 3
        
        
        let eventItemRef = self.rootRef.child("requests").childByAutoId()
        
        
        
        eventItemRef.setValue(userItem.toAnyObject())
        
        let alert = UIAlertController(title: "Guess What", message: "Request Sent Successfully", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    
    
    
    }

//send feedback
    @IBAction func SendFeedBack(_ sender: Any) {
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        let userItem = EntityFeed(Sender: self.emeli,
                                     Receiver: self.ems,
                                     message: feed.text!)       // 3
        //   ts: ts!)       // 3
        
        
        let eventItemRef = self.rootRef.child("Feed").childByAutoId()
        
        
        
        eventItemRef.setValue(userItem.toAnyObject())
        
        
        
        let alert = UIAlertController(title: "Guess What", message: "Your Feed Back Has Been Sent :D", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
        
        
        feed.text = ""
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
