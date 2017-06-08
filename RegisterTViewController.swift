//
//  UserDetailViewController.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 3/6/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//

import UIKit
import FirebaseAuth
import  FirebaseDatabase
import MobileCoreServices
import FirebaseAuth
import Firebase
import Photos
import SystemConfiguration
import MapKit


class RegisterTViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate  {
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var urlImageUser : String = ""
    
    
    var long:String!=""
    var lat:String!=""
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var indicator = UIActivityIndicatorView()

//    @IBOutlet var imageViewProfile: UIImageView!
//    @IBOutlet var email: UITextField!
//    @IBOutlet var password: UITextField!
//    @IBOutlet var spec: UITextField!
//    @IBOutlet var price: UITextField!
//    //
//    @IBOutlet var phones: UITextField!
    
    @IBOutlet var imageViewProfile: UIImageView!
    
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
 
    @IBOutlet var phones: UITextField!
    @IBOutlet var spec: UITextField!
    @IBOutlet var price: UITextField!
    //
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        indicator.stopAnimating()
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedInfo = info [UIImagePickerControllerOriginalImage] as! UIImage
        
        imageViewProfile.image = selectedInfo
        dismiss(animated: true, completion: nil)
        print("d5alet")
        //  print(imageViewProfile.image.)
        
        //
        //        if let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
        //            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL as URL], options: nil)
        //            let filename = result.firstObject.self
        //            print(filename)
        //            print(result)
        //            print(imageURL)
        //            imageViewProfile.image = filename
        //            dismiss(animated: true, completion: nil)
        //        }
        
    }
    
    
    
    
    
    
    
    @IBAction func taps(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true, completion:  nil)
        print("clickit")
    }
    
    
    
    
    @IBAction func RegisterTeat(_ sender: Any) {
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            currentLocation = locManager.location
//            if currentLocation.coordinate.latitude != nil{
//                self.lat = "\(currentLocation.coordinate.latitude)"
//            }
//            else {
                self.lat = "36.898392"
//            }
//            if currentLocation.coordinate.longitude != nil{
//                self.long = "\(currentLocation.coordinate.longitude)"
//            }
//            else
//            {
                self.long = "10.189732"
       //}
        }
        
        
        
        // Data in memory
        var data = NSData()
        data = UIImageJPEGRepresentation(imageViewProfile.image!, 0.8)! as NSData
        /***********************/
        let stringFromDate = Date().iso8601
        if let dateFromString = stringFromDate.dateFromISO8601 {
            print("timeeeeeee",dateFromString.iso8601)      // "2016-06-18T05:18:27.935Z"
        }
        // "2016-06-18T05:18:27.935Z"
        /************************/
        // Create a reference to the file you want to upload
        let imageRef = storage.reference().child("images_users").child(stringFromDate)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        // Upload the file to the path "images/rivers.jpg"
        _ = imageRef.put(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metaData!.downloadURL()!.absoluteString
                
                
                
                print(self.email.text as Any)
                print (self.password.text as Any)
                
                FIRAuth.auth()?.createUser(withEmail: self.email.text as Any as! String, password:
                    self.password.text as Any as! String,completion: { (user, error) in
                        
                        print(downloadURL)
                        
                        if user != nil{
                            print ("user exists and created")
                            
                            let date = "02/27/1994"
                            // let dateFormatter = DateFormatter()
                            // dateFormatter.dateFormat = "MM/dd/yyyy"
                            // let dateString = dateFormatter.string(from: date)
                            
                            // 2
                            let Firstname = self.name.text

                            let phone = self.phones.text
                            let email = self.email.text
                            let spec = self.spec.text
                            let price = self.price.text
                            let ts:String!="t"
                            
                            //let nrating = self.nrating.text
                            let rating:Double!=1
                            let nrating:Double!=1
                            
                            //  let rating = self.rating.text
                            //                    let nrating:String! = "1"
                            //                    let rating:String! = "1"
                            // let ts="s"
                            //            print (self.ts.text)
                            
                            
                            
                            
                            
                            
                            let userItem = EntityUser(phone : phone!,
                                                      email:email!,
                                                      price: price!,
                                                      nrating : nrating!,
                                                      rating : rating!,
                                                      spec: spec!,
                                                      lat: self.lat!,
                                                      long: self.long!,
                                                       Firstname: Firstname!,
                                                      ts: ts!, urlImage : downloadURL)       // 3
                            let eventItemRef = self.rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
                            
                            
                            
                            eventItemRef.setValue(userItem.toAnyObject())
                            self.performSegue(withIdentifier: "homes", sender: self)
                            
                        }
                        else{
                            print ("no user ")
                            let alert = UIAlertController(title: "Guess What", message: "Wrong Data entred", preferredStyle: UIAlertControllerStyle.alert)
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                            
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                })
                
                
                
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
                
                
            }
        }
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
        phones.delegate = self
        price.delegate = self
        
        locManager.delegate = self
        //manager.desiredAccuracy = kCLLocationAccuracyBest
        
        locManager.requestWhenInUseAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
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
