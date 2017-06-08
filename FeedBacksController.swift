//
//  ContactsVC.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 3/28/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//


import UIKit
import FirebaseAuth
import  FirebaseDatabase
import MobileCoreServices
import FirebaseAuth
import Firebase
import SystemConfiguration

class FeedBacksController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // fileprivate var items: [EntityRequest] = []
    
    var items : [EntityFeed] = [EntityFeed] ()
    var itemsUser : [EntityUser] = [EntityUser] ()

    
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var usera : EntityUser? = EntityUser (spec: "a",price: "a")
    var feedEmail : String = "a"

    @IBOutlet var imgProfile: UIImageView!
    var tab : [EntityUser] = [EntityUser] ()
    //  items   = [EntityRequest]()
    
    
    let myArray = ["citroen","ford focus","Alfa romeo","Nissan"]
    let imgArray = ["a.png","b.png","c.png","d.png"]
    
    //
    let prix = ["33 950","35 150","44 300","37 500"]
    let puiss = ["4 cv","5 cv","5 cv","7 cv"]
    let energ = ["essence","essence","essence","diesel"]
    var hismail = FIRAuth.auth()?.currentUser?.email
    
    var emails : String = "a"
    //@IBOutlet weak var tableView: UITableView!
    //    @IBOutlet var tableView: UITableView!
    
    
    var indicator = UIActivityIndicatorView()
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        indicator.stopAnimating()
        
    }
    
    @IBOutlet var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
   
        
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
        items = [EntityFeed]()
        getAllEvents()
        
    }
    
    func getAllEvents()   {
        _ = FIRDatabase.database().reference(withPath: "Feed").queryOrdered(byChild: "Receiver").queryEqual(toValue: feedEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.items.append(EntityFeed(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                if (self.items.count-1 >= 0) {
                for i in 0...self.items.count-1 {
                    //print(hismail)
                    //**************************************
              
                    //**************************************
                    print(self.items[i].message)
                }
                }
                else {      let alert = UIAlertController(title: "Guess What", message: "No one Posted a feedback yet", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)}
                
            }
        self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return items.count
        
        
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        
//        self.performSegue(withIdentifier: "hisprofile", sender: emails)
//        
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:"myCell")!
        
        
        
        let lblNom:UILabel = cell.viewWithTag(101) as! UILabel
        
        //  zidha = lblNom.text!
        
        let lblDate:UILabel = cell.viewWithTag(111) as! UILabel
        lblDate.text = "Said: "+items[indexPath.row].message

        let imgProfile:UIImageView = cell.viewWithTag(103) as! UIImageView
        //
        _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: self.items[indexPath.row].Sender).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotss = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshotss {
                    self.itemsUser.append(EntityUser(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                if (self.itemsUser.count > 0){
                for i in 0...self.itemsUser.count-1 {
                    print(self.itemsUser[i].email)
            
                    if (self.itemsUser[i].urlImage != nil){
                    print(self.itemsUser[i].urlImage)
                        lblNom.text = self.itemsUser[i].Firstname

                      let url = URL(string: self.itemsUser[i].urlImage as! String)
                        imgProfile.kf.setImage(with: url)}
                    else {}

                    
                    }}
            
            else {print("mahnech")}
            
                
            }
            
           // self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
        
        
        //            //            imgProfile.image = #imageLiteral(resourceName: "lol")//UIImage(named: "lol")
        //imgProfile.image =  UIImage(named: items[indexPath.row].urlImage as! String)
        

        
   
        
        
        
        
        
        return cell
    }
    
    
    
    
    
}




