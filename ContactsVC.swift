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

class ContactsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // fileprivate var items: [EntityRequest] = []
    
    var items : [EntityMessage] = [EntityMessage] ()
    var itemsUser : [EntityUser] = [EntityUser] ()
    
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var valeur: String = "aa"
    
    var tab : [EntityUser] = [EntityUser] ()
    //  items   = [EntityRequest]()
    
    
    let myArray = ["citroen","ford focus","Alfa romeo","Nissan"]
    let imgArray = ["a.png","b.png","c.png","d.png"]
    
    //
    let prix = ["33 950","35 150","44 300","37 500"]
    let puiss = ["4 cv","5 cv","5 cv","7 cv"]
    let energ = ["essence","essence","essence","diesel"]
    var hismail = FIRAuth.auth()?.currentUser?.email
    
    var zidha:String = ""
    //@IBOutlet weak var tableView: UITableView!
//    @IBOutlet var tableView: UITableView!
    var indicator = UIActivityIndicatorView()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        indicator.stopAnimating()
        
    }
    
    @IBOutlet var tableView: UITableView!
    //    var   emails:String
    //    var phones:String
    //
    //    var urls:String
    //    var url:Resource
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //
        //        let userItem = EntityRequest(Sender : "raid@gmail.com",
        //                                  Receiver: "farabi@gmail.gmail")       // 3
        //
        //
        //        let eventItemRef = self.rootRef.child("requests").childByAutoId()
        //
        //
        //         eventItemRef.setValue(userItem.toAnyObject())
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goMessages" {
            let svc : ChatVC = segue.destination as! ChatVC
            svc.valeur = sender as! String
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
        itemsUser = [EntityUser]()
        items = [EntityMessage]()

        getAllEvents()
        
        
    }
    
    func getAllEvents()   {
        _ = FIRDatabase.database().reference(withPath: "messages").queryOrdered(byChild: "Receiver").queryEqual(toValue: SMNavigationController.users.email).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.items.append(EntityMessage(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                
                if (self.items.count > 0){
                for i in 0...self.items.count-1 {
                    //print(hismail)
                    
                    print(self.items[i].Receiver)
                    
                }
            }
            else {
                
                let alert = UIAlertController(title: "Guess What", message: "No Messages for the moment", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         valeur = items[indexPath.row].Sender
        print("msata valeur 1")
        print(valeur)
     self.performSegue(withIdentifier: "goMessages", sender: valeur)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:"myCell")!
        
        
        
        let lblNom:UILabel = cell.viewWithTag(101) as! UILabel
        
        //  zidha = lblNom.text!
        
        let lblDate:UILabel = cell.viewWithTag(102) as! UILabel
        
        let imgProfile:UIImageView = cell.viewWithTag(103) as! UIImageView
        
        _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: self.items[indexPath.row].Sender).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotss = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshotss {
                    self.itemsUser.append(EntityUser(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                for i in 0...self.itemsUser.count-1 {
                    
                    let url = URL(string: self.itemsUser[i].urlImage as! String)
                    imgProfile.kf.setImage(with: url)
                    lblNom.text = self.itemsUser[i].Firstname
                    lblDate.text = self.itemsUser[i].phone


                    //                print("khraaa")
                    //                    print(self.itemsUser[i].email)
                    
                    
                }
                
            }
            
            //  self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let ref = FIRDatabase.database().reference(withPath: "requests").queryOrdered(byChild: "Sender").queryEqual(toValue: items[indexPath.row].Sender).observeSingleEvent(of: .value, with: { (snapshot) in
//                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                    for snap in snapshots {
//                        self.items.append(EntityRequest(snap: snap))
//                        
//                        let rafas =  FIRDatabase.database().reference(withPath: "requests").child(snapshots[0].key).updateChildValues(["status": "2"])
//                        
//                    }
//                    //
//                    for i in 0...self.items.count-1 {
//                        print("zzzzzzzzzzz")
//                        //print(hismail)
//                        
//                        print(self.items[i].Sender)
//                        print("zzzzzzzzz")
//                        
//                    }
//                    
//                }
//            })
//            items.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            
//        }
//        
//        
//        
//        
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let ref = FIRDatabase.database().reference(withPath: "requests").queryOrdered(byChild: "Sender").queryEqual(toValue: items[indexPath.row].Sender).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshots {
//                    self.items.append(EntityRequest(snap: snap))
//                    
//                    let rafas =  FIRDatabase.database().reference(withPath: "requests").child(snapshots[0].key).updateChildValues(["status": "1"])
//                    
//                }
//                //
//                for i in 0...self.items.count-1 {
//                    print("zzzzzzzzzzz")
//                    //print(hismail)
//                    
//                    print(self.items[i].Sender)
//                    print("zzzzzzzzz")
//                    
//                }
//                
//            }
//        })
//        items.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
    
    
    
    
       
}




