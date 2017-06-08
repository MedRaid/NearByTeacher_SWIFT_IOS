//
//  MyTeachersController.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 4/19/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//

import UIKit
import FirebaseAuth
import  FirebaseDatabase
import MobileCoreServices
import FirebaseAuth
import Firebase
import SystemConfiguration
import Cosmos

class MyTeachersController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var items : [EntityRequest] = [EntityRequest] ()
    var itemsaf : [EntityRequest] = [EntityRequest] ()
    
    var itemsUser : [EntityUser] = [EntityUser] ()
    var itemsUsera : [EntityRequest] = [EntityRequest] ()
    var itemsUsers : [EntityRequest] = [EntityRequest] ()
    
    var del:String = "a"

    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var valeur: String = "aa"
    
    var tab : [EntityRequest] = [EntityRequest] ()
    //  items   = [EntityRequest]()
    
    
    let myArray = ["citroen","ford focus","Alfa romeo","Nissan"]
    let imgArray = ["a.png","b.png","c.png","d.png"]
    
    //
    let prix = ["33 950","35 150","44 300","37 500"]
    let puiss = ["4 cv","5 cv","5 cv","7 cv"]
    let energ = ["essence","essence","essence","diesel"]
    var hismail = FIRAuth.auth()?.currentUser?.email
    
    var zidha:String = ""
   
    
    
    var indicator = UIActivityIndicatorView()
    
    override func viewDidAppear(_ animated: Bool) {
        indicator.stopAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
        items = [EntityRequest]()
        itemsaf = [EntityRequest]()
        itemsUser = [EntityUser]()
        itemsUsera = [EntityRequest]()
        itemsUsers = [EntityRequest]()
        getAllEvents()
        
        
        
    }
    

    

    func getAllEvents()   {
        print("d5alt allEvents **************")
        print(SMNavigationController.users.email)

        _ = FIRDatabase.database().reference(withPath: "requests").queryOrdered(byChild: "Receiver").queryEqual(toValue: SMNavigationController.users.email).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.items.append(EntityRequest(snap: snap))
                    
                    
                    
                }
                var j = 0
                if (self.items.count > 0){
                    print(" items feha  **************")

                    for i in 0...self.items.count-1
                    {
                        
                        
                        if (self.items.count > 0)
                        {
                            if (self.items[i].status == "1"){
                                print("zzzzzzzzzzz")
                                
                                self.itemsaf.insert(self.items[i], at: j)
                                print("KKKKKKKK")
                                print(self.itemsaf[j].Sender)
                                
                                j += 1
                            }
                            else {
                                // self.items.remove(at: i)
                                //self.items[i] = self.items[i+1]
                            }
                        }
                        
                        
                    }
                    if (self.itemsaf.isEmpty)
                    {
                        
                        let alert = UIAlertController(title: "Guess What", message: "No Students Added for the moment", preferredStyle: UIAlertControllerStyle.alert)
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                        
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)}
                    
                    
                }
                if (self.items.isEmpty)
                {
                    
                    let alert = UIAlertController(title: "Guess What", message: "No Students Added for the moment", preferredStyle: UIAlertControllerStyle.alert)
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
        
        
        return itemsaf.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:"myCell")!
        
        
        
        let lblNom:UILabel = cell.viewWithTag(101) as! UILabel
        
        //  zidha = lblNom.text!
        
        let lblDate:UILabel = cell.viewWithTag(102) as! UILabel
        
        let imgProfile:UIImageView = cell.viewWithTag(103) as! UIImageView
        
        
        _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: self.itemsaf[indexPath.row].Sender).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotss = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshotss {
                    self.itemsUser.append(EntityUser(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                for i in 0...self.itemsUser.count-1 {
                    
                    let url = URL(string: self.itemsUser[i].urlImage as! String)
                    imgProfile.kf.setImage(with: url)
                    lblNom.text = " "+self.itemsUser[i].Firstname
                    lblDate.text = " Phone: "+self.itemsUser[i].phone
                    
//                    if(self.itemsUser[i].ts == "t")
//                    {
//                        let cosmosView:CosmosView = cell.viewWithTag(55) as! CosmosView
//
//                    let  tratin : Double =   self.itemsUser[i].rating
//                    let  nratin : Double =   self.itemsUser[i].nrating
//                        cosmosView.rating = tratin/nratin}
//                   
                    
                    
                }
                
            }
            
            //  self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
      //  let cosmosView:CosmosView = cell.viewWithTag(55) as! CosmosView

    //    cosmosView.settings.updateOnTouch = false

        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//            let ref = FIRDatabase.database().reference(withPath: "requests").queryOrdered(byChild: "Sender").queryEqual(toValue: itemsaf[indexPath.row].Sender).observeSingleEvent(of: .value, with: { (snapshot) in
//                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                    for snap in snapshots {
//                        self.itemsUsera.append(EntityRequest(snap: snap))
//                        print("NNNNNNNNNNNN")
//                        self.del = snap.key as! String
//                        print(self.del)
//                        
//                        let rafas =  FIRDatabase.database().reference(withPath: "requests").child(self.del).updateChildValues(["status": "2"])
//                        
//                    }
//                    //
//                    
//                    
//                }
//            })
//            
//        }
//        print("FFFFFFFFFFFF")
//        print(self.del)
//        
//        itemsaf.remove(at: indexPath.row)
//        //tableView.deleteRows(at: [indexPath], with: .fade)
//        self.tableView.reloadData()
//        
//        if (itemsaf.count-1 < 0)
//        {
//            
//            let alert = UIAlertController(title: "Guess What", message: "No Added Students for the moment", preferredStyle: UIAlertControllerStyle.alert)
//            // add an action (button)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//            
//            
//            // show the alert
//            self.present(alert, animated: true, completion: nil)}
//        
//        
//    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let ref = FIRDatabase.database().reference(withPath: "requests").queryOrdered(byChild: "Sender").queryEqual(toValue: itemsaf[indexPath.row].Sender).observeSingleEvent(of: .value, with: { (snapshot) in
    //            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
    //                for snap in snapshots {
    //                    self.itemsUsers.append(EntityRequest(snap: snap))
    //
    //                    print("NNNNNNNNNNNN")
    //                    self.ad = snap.key as! String
    //                    print(self.ad)
    //
    //                    let rafas =  FIRDatabase.database().reference(withPath: "requests").child(self.ad).updateChildValues(["status": ""])
    //
    //                }
    //                //
    //
    //
    //            }
    //        })
    //        itemsaf.remove(at: indexPath.row)
    //        //tableView.deleteRows(at: [indexPath], with: .fade)
    //        self.tableView.reloadData()
    //        if (itemsaf.count-1 < 0)
    //        {
    //
    //            let alert = UIAlertController(title: "Guess What", message: "No pending requests for the moment", preferredStyle: UIAlertControllerStyle.alert)
    //            // add an action (button)
    //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    //            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    //
    //
    //            // show the alert
    //            self.present(alert, animated: true, completion: nil)}
    //        
    //    }
    
    
    
}
