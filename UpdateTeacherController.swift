//
//  UpdateTeacherController.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 3/8/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//

import UIKit
import FirebaseAuth
import  FirebaseDatabase
import MobileCoreServices
import FirebaseAuth
import Firebase
import SystemConfiguration

class UpdateTeacherController: UIViewController {
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil

//    @IBOutlet var phones: UITextField!
//    
//    @IBOutlet var prices: UITextField!
//    @IBOutlet var specs: UITextField!
//    @IBOutlet var emails: UITextField!
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
    
    @IBOutlet var phones: UILabel!
    
    @IBOutlet var emails: UILabel!
    @IBOutlet var specs: UILabel!
    
    @IBOutlet var prices: UILabel!
    
    
    @IBAction func UpdateT(_ sender: Any) {
        let user = FIRAuth.auth()?.currentUser
        // The user's ID, unique to the Firebase project.
        // Do NOT use this value to authenticate with your backend server,
        // if you have one. Use getTokenWithCompletion:completion: instead.
        let email = user?.email
        print (email as Any)
        print("hani lgitooo DONNNE")
        let tel:String!=phones.text
        let price:String!=prices.text
        let spec:String!=specs.text
        //  let tel:String!=phones.text
        
        
        
   
        rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["phone": tel,"price": price,"spec": spec])

//        
//        let ts:String!="t"
//        // let ts="s"
//        let userItem = EntityUser(phone : tel!,email:email!,ts: ts!,price: price!,spec: spec!)       // 3
//      
        self.performSegue(withIdentifier: "returnPro", sender: self)
        
        
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if ( rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!) != nil ){
            
            
            rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
                self.emails.text = snapshot.childSnapshot(forPath: "email").value as? String
                
                self.phones.text = snapshot.childSnapshot(forPath: "phone").value as? String
                
                 self.prices.text = snapshot.childSnapshot(forPath: "price").value as? String
                 self.specs.text = snapshot.childSnapshot(forPath: "spec").value as? String
                //                self.tvLastName.text = snapshot.childSnapshot(forPath: "lastname").value as! String
                //                self.tvCountry.text = snapshot.childSnapshot(forPath: "country").value as! String
                //                self.tvPhone.text = snapshot.childSnapshot(forPath: "phone").value as! String
                //                let s =  snapshot.childSnapshot(forPath: "sexe").value as! String
                //
                //                self.tvBirthday.text = snapshot.childSnapshot(forPath: "birthday").value as! String
                //                // self.setNavigationBarItem()
                //                self.urlImageUser =  snapshot.childSnapshot(forPath: "urlImageUser").value as! String
                
            })
            
            
            
            
            // Do any additional setup after loading the view.
        }
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
