//
//  LoginViewController.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 3/5/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase
import MobileCoreServices
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import SystemConfiguration

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
//class LoginViewController: UIViewController{
    
    
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var items : [EntityRequest] = [EntityRequest] ()
    var uses : [EntityUser] = [EntityUser] ()
    let valeur:String="aaaaa"

    
     @IBAction func seg(_ sender: Any) {
        performSegue(withIdentifier: "lista", sender: self )

     }
    
//    override func viewWillAppear(_ animated: Bool) {

//    }
    
    
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        print("sysseccesfully out")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        
        if error != nil {
            print ("Facebook Error dude ")
        }
        print("successss facebook")
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if error != nil {
                // ...
                return
              
            }
   
            let emailf = user?.email
           // let pic = user?.s
              let _:String!=user?.uid
           // print(emailf)
           let pic = FBSDKGraphRequest(graphPath: "/me/picture", parameters: ["height":300,"width":300,"redirect":false], httpMethod: "GET")

          //  let pic = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "picture"], httpMethod: "GET")

           // pic?.start{(connection, result, error) -> Void in
           pic?.start(completionHandler: {(connection, result, error) -> Void in
                if (error == nil)
                {
                    print("ouyouyouyouy")
                   print(result!)
                    _ = (result as AnyObject).object(forKey: "url")
                  //  print(ss!)
            let dictionary = result as? NSDictionary
                 let data = dictionary?.object(forKey: "data")
            //let data = dictionary?.
                   // let urlPic = ((data as AnyObject).object(forKey: "url"))! as! String
                    let urlPic = (data as AnyObject).object(forKey : "url")
                            let _:String!="azerty"
                    
                 //   let kasi = (data as AnyObject).object(forKey: "url")
                    print("oooooooooooooooooooooooo")

                                print(emailf!)
                    let emaill:String! = emailf
                     print(emaill)
                    print("oooooooooooooooooooooooo")

                     let user = FIRAuth.auth()?.currentUser
                                      print(urlPic!)
                                        print("lalalalalallal")
                                        
                                        if user != nil{
                                            
                                            
                                            _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: emaill).observeSingleEvent(of: .value, with: { (snapshot) in
                                                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                                    for snap in snapshots {
                                                        self.uses.append(EntityUser(snap: snap))
                                                        
                                                        
                                                        
                                                        //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                                                    }
                                                    
                                                    if (self.uses.count-1 >= 0){
                                                    for i in 0...self.uses.count-1 {
                                                        print("zzzzzzzzzzz")
                                                        //print(hismail)
                                                        
                                                        print(self.uses[i].email)
                                                        print(self.uses.count-1)

                                                        print("zzzzzzzzz")
                                                        
                                                    }

                                                    }
                                                    else {      print ("user exists and created")
                                                        
                                                        let phone:String!="99899999"
                                                        _ = emailf
                                                        
                                                        let ts:String!="s"
                                                        
                                                        let userItem = EntityUser(phone : phone!,
                                                                                  email:emaill!,
                                                                                  ts: ts!, urlImage : urlPic!)       // 3
                                                        let eventItemRef = self.rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
                                                        
                                                        
                                                        
                                                        eventItemRef.setValue(userItem.toAnyObject())
                                                      //  self.performSegue(withIdentifier: "homelog2", sender: self)
                                                    }
                                                }

                                                if(FBSDKAccessToken.current() != nil){
                                                    self.performSegue(withIdentifier: "homelog2", sender: self)
                                                }else{
                                                    // not logged in
                                                }
                                                
                                                    })

                                            { (error) in
                                                print(error.localizedDescription)
                                            }
                                            
                                            
                                            
                                      
//
                                        }
                                        else{
                                            let alert = UIAlertController(title: "Guess What", message: "Wrong Email or Password", preferredStyle: UIAlertControllerStyle.alert)
                                            // add an action (button)
                                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                                            
                                            
                                            // show the alert
                                            self.present(alert, animated: true, completion: nil)}
                    
                              //  })
                                
                                
                                
                                // 2
                                //                let userItem = EntityUser(Firstname: firstname!, Lastname: lastName!, city: city!
                                //                    ,country :country!,sexe :sex,phone : phone!,birthday : dateString!, urlImage : downloadURL)       // 3
                                //                let eventItemRef = self.rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
                                //
                                //                // 4
                                //                eventItemRef.setValue(userItem.toAnyObject())
                                
                                
                                /*let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginMyCityMyStory") as! UINavigationController!
                                 self.show(nextViewController!, sender:nil)*/
                                //    self.navigationController?.popToRootViewController(animated: true)
                                
                                
                            
                        

                    
//
                
            }
            //let uid = user?.uid
          //  print(uid)

         //   let photoURL = user?.photoURL
            
        }
            )
        }
        
    }

  
    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var fb: UIButton!
 
    
    
    @IBAction func loggin(_ sender: Any) {
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required at first time running the app to load images and videos ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        
        print(email.text as Any)
        print (password.text as Any)
        
        FIRAuth.auth()?.signIn(withEmail: email.text as Any as! String, password:
            password.text as Any as! String,completion: { (user, error) in
                
                if user != nil{
                    print ("user exists and logged")
                    UserDefaults(suiteName: "group.NearByTeachers")!.set(self.email.text, forKey: "emails")
                    print("\(UserDefaults(suiteName: "group.NearByTeachers")!.value(forKey: "emails")!)"+"emmmmmmmmail")
                    
                    
                    
                    UserDefaults(suiteName: "group.NearByTeachers")!.set(self.email.text, forKey: "uid")
                    print("\(UserDefaults(suiteName: "group.NearByTeachers")!.value(forKey: "uid")!)")
                    
                    
                    

                    self.performSegue(withIdentifier: "homelog2", sender: self)
                    
                }
                else{
                    print ("no user ")
                    let alert = UIAlertController(title: "Guess What", message: "Wrong Email or Password", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                
                }
                
        })
        

        
        
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
        
        
//        let loginButton = FBSDKLoginButton()
//  //      loginButton.center = self.view.center
//        //loginButton.frame.origin = CGPoint(x: 50, y: 50)
//        
//    
//        
//        
//      loginButton.frame.origin = CGPoint( 70, 500)
//
//        view.addSubview(loginButton)
//        loginButton.delegate = self
        
        let loginButton = FBSDKLoginButton()
             loginButton.readPermissions = [ "email","public_profile" ]
     //  loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        let letfCons =
            NSLayoutConstraint(item: loginButton,
                               attribute: .leftMargin ,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .leftMargin ,
                               multiplier: 1.0,
                               constant: 20)
        
        let rightCons =
            NSLayoutConstraint(item: loginButton,
                               attribute: .rightMargin ,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .rightMargin ,
                               multiplier: 1.0,
                               constant: -20)
        
        
        let topCons =
            NSLayoutConstraint(item: loginButton,
                               attribute: .bottom  ,
                               relatedBy: .equal,
                               toItem: bottomLayoutGuide,
                               attribute: .top ,
                               multiplier: 1.0,
                               constant: -40)
        
        loginButton.delegate = self
        view.addConstraints([letfCons, rightCons, topCons ])

       //  loginButton.addConstraint(myConstraint)
        
        
        if(FBSDKAccessToken.current() != nil){
            self.performSegue(withIdentifier: "homelog2", sender: self)
            print("fama facebook")
        }else{
            print("famach facebook")
        }
   // let ref = FIRDatabase.database().reference(withPath: "requests").queryOrdered(byChild: "Receiver").queryEqual(toValue: "rad@rad.rad")
    
// temmmmmmmmmchiiiii RECHERCHEEE ARRA  :d
     
//             let ref = FIRDatabase.database().reference(withPath: "requests").queryOrdered(byChild: "Receiver").queryEqual(toValue: "rad@rad.rad").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshots {
//                    self.items.append(EntityRequest(snap: snap))
//                    
//                   
//                   
//                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
//                }
//                for i in 0...self.items.count-1 {
//                    print(self.items[i].Sender)
//                }
//                
//                
//            }
//            
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
        
        
        
        
        
//        ref.observeSingleEvent(of: .childAdded , with: { snapshot in
//      //  ref.observeSingleEventOfType(.ChildAdded, block: { snapshot in
//            print("zzzzzz")
//            print(snapshot.childSnapshot(forPath: "Sender"))
//            print("zzzzzz")
//
//        })
//        
        
        
//           items = [EntityRequest]()
//        
//        rootRef.child("requests").child("-Kf8_TqIpJnBrNT7PN4K").queryEqual(toValue: "raid@gmail.com")
//        .observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for child in snapshot.children {
//                    let name = child.value["Name"]
//                    print(name)
//                }
//            //    self.tableView.reloadData()
//                
//            }
//       // rootRef.child("requests").child("-Kf8ajB5XUEf3AyGGLjt").updateChildValues(["Sender": "kartha@gmail.com"])
//
//    
//        })
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
