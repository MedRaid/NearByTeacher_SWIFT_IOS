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

class SearchResultController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // fileprivate var items: [EntityRequest] = []
    
    var items : [EntityUser] = [EntityUser] ()
    
    var indicator = UIActivityIndicatorView()

    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var usera : EntityUser? = EntityUser (spec: "a",price: "a")
    
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
    @IBOutlet var tableView: UITableView!
    @IBOutlet var photoImage: UIImageView!
    //    var   emails:String
    //    var phones:String
    //
    //    var urls:String
    //    var url:Resource
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        indicator.stopAnimating()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
        items = [EntityUser]()
        getAllEvents()
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
        
        
    }

    
    
  
    
    func getAllEvents()   {
        _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "price").queryEqual(toValue: usera?.price).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.items.append(EntityUser(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                if (self.items.count > 0){
                for i in 0...self.items.count-1 {
                    //print(hismail)
                    
                    print(self.items[i].email)
                    self.emails = self.items[i].email
                    print("ahhhhhhhhhhhhhhhhhhhhhh")
                    print(self.emails)
                    
                }
                
                
                }
                if (self.items.isEmpty) {
                
                    let alert = UIAlertController(title: "Guess What", message: "No Teachers with such details", preferredStyle: UIAlertControllerStyle.alert)
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
        indicator.stopAnimating()

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hisprofile" {
            let svc : hisprofileController = segue.destination as! hisprofileController
            svc.emails = sender as! String!
            
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
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        
        //self.performSegue(withIdentifier: "hisprofile", sender: emails)
        let vc = TeacherController()
        vc.id=self.items[0]
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:"myCell")!
        
        
        
        let lblNom:UILabel = cell.viewWithTag(101) as! UILabel
        lblNom.text = items[indexPath.row].Firstname
        
        //  zidha = lblNom.text!
        
        let lblDate:UILabel = cell.viewWithTag(102) as! UILabel
        lblDate.text = items[indexPath.row].phone
        
                  let imgProfile:UIImageView = cell.viewWithTag(103) as! UIImageView
        //
        //            //            imgProfile.image = #imageLiteral(resourceName: "lol")//UIImage(named: "lol")
                   //imgProfile.image =  UIImage(named: items[indexPath.row].urlImage as! String)
        let url = URL(string: items[indexPath.row].urlImage as! String)

        
        imgProfile.kf.setImage(with: url)
        
   
        
        
        
        return cell
    }
    
   
    
    
    
}




