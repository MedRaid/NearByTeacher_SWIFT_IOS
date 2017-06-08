//
//  ProfileController.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 3/7/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MobileCoreServices
import FirebaseAuth
import Firebase
import SystemConfiguration


//import Kingfisher
import Kingfisher

class ProfileTeatcherController: UIViewController{
    
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    
    @IBOutlet var photoimageView: UIImageView!
 
    //@IBOutlet var photoimageView: UIImageView!
//    @IBOutlet var emails: UILabel!
//    @IBOutlet var phones: UILabel!
//    @IBOutlet var specs: UILabel!
//    @IBOutlet var prices: UILabel!
    var urlImage : String = ""
    
    @IBOutlet var phones: UILabel!
    @IBOutlet var emails: UILabel!
    /*************/
    @IBOutlet var specs: UILabel!
    @IBOutlet var prices: UILabel!
    
    /***************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        if ( rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!) != nil ){
            
            
            rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
                self.emails.text = (snapshot.childSnapshot(forPath: "email").value as? String)
                
                self.phones.text = snapshot.childSnapshot(forPath: "phone").value as! String
                
                
                
                self.specs.text = snapshot.childSnapshot(forPath: "spec").value as! String
                
                self.prices.text = snapshot.childSnapshot(forPath: "price").value as! String
                
                self.urlImage = snapshot.childSnapshot(forPath: "urlImageUser").value as! String
                
                let url = URL(string: self.urlImage)
               // photoimageView.k
                self.photoimageView.kf.setImage(with: url)

                //                self.tvLastName.text = snapshot.childSnapshot(forPath: "lastname").value as! String
                //                self.tvCountry.text = snapshot.childSnapshot(forPath: "country").value as! String
                //                self.tvPhone.text = snapshot.childSnapshot(forPath: "phone").value as! String
                //                let s =  snapshot.childSnapshot(forPath: "sexe").value as! String
                //
                //                self.tvBirthday.text = snapshot.childSnapshot(forPath: "birthday").value as! String
                //                // self.setNavigationBarItem()
                //                self.urlImageUser =  snapshot.childSnapshot(forPath: "urlImageUser").value as! String
                
            })
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        //
        //        let user = FIRAuth.auth()?.currentUser
        //        let email = user?.email
        //        emails.text=user?.email
        //       // phones.text=user?.
        //        print (email as Any)
        //        print("fel profile taw")
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
