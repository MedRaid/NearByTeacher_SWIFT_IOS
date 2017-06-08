//
//  Demo2Controller.swift
//  StretchHeaderDemo
//
//  Created by yamaguchi on 2016/03/27.
//  Copyright © 2016年 h.yamaguchi. All rights reserved.
//

import UIKit
import SystemConfiguration
import FirebaseAuth
import  FirebaseDatabase
import MobileCoreServices
import Firebase
import Cosmos

class MyTeacherDetailViewController: UITableViewController {
    var id:EntityUser = EntityUser();
    var header : StretchHeader!
    var rating=CosmosView();
    var indicator = UIActivityIndicatorView()
    var itemsUser : [EntityUser] = [EntityUser] ()
    var itemsUserres : [EntityUser] = [EntityUser] ()

    var del:String = "a"
    var delresultat:String = "a"

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        //  tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        setupHeaderView()
    }
    
    func setupHeaderView() {
        
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        do {
            let url = URL(string: id.urlImage as! String)
            header.imageView?.kf.setImage(with: url)
            
            
//            header.imageView?.sd_setImage(with: URL(string: id.getProperty("pic") as! String), placeholderImage: UIImage(named: "school.jpg"))
        }
     
        
        
        
        // custom
        
        rating.frame = CGRect(x: 50, y: header.frame.size.height - 90, width: header.frame.size.width - 20, height: 40)
        let didrate  =  SMNavigationController.users.rated

        
        
        if didrate.range(of:self.id.email as String) != nil{
            rating.settings.updateOnTouch = false
            
            rating.didTouchCosmos = alert
        }
        
        
        rating.didFinishTouchingCosmos = rate
        
        rating.settings.filledColor = UIColor.orange
        
        // Set the border color of an empty star
        rating.settings.emptyBorderColor = UIColor.orange
        
        // Set the border color of a filled star
        rating.settings.filledBorderColor = UIColor.orange
        rating.settings.starSize=40
        
        rating.settings.fillMode = .precise
        rating.settings.emptyBorderColor = UIColor.white
        
        // Set the border color of a filled star
        rating.settings.filledBorderColor = UIColor.white
        
        //rating.text="rating"
        rating.settings.starMargin=10
        let  tratin : Double =   id.rating
        let  nratin : Double =   id.nrating
        
        
        rating.rating=tratin/nratin
        
        let label = UIOutlinedLabel()
        label.frame = CGRect( x: self.view.frame.width / 4, y: header.frame.size.height - 40, width: header.frame.size.width - 20, height: 40)
        label.textColor = UIColor.white
        label.text = id.Firstname
        label.font = UIFont.boldSystemFont(ofSize: 24)
        header.addSubview(label)
        header.addSubview(rating)
        
        tableView.tableHeaderView = header
    }
    
    // MARK: - ScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        
        if indexPath.row==0
        {
            cell.textLabel?.text =  (NSString(format: "%@", id.price) as String)+"$" as String
            cell.detailTextLabel?.text=" Price Per Session"
            cell.imageView?.image = UIImage(named: "money");

        }
        
        
        if indexPath.row==1
        {
            cell.textLabel?.text = " Phone number"
            cell.detailTextLabel?.text = id.phone
            cell.imageView?.image = UIImage(named: "phones");
        }
        
        
        if indexPath.row==2
        {
            cell.textLabel?.text = " Teacher Speciality"
            cell.detailTextLabel?.text = id.spec
            cell.imageView?.image = UIImage(named: "spec4");

        }
        
        if indexPath.row==3
        {
            cell.textLabel?.text = " Email"
            cell.detailTextLabel?.text=id.email as String?
            cell.imageView?.image = UIImage(named: "em");

        }
        
        
//        
//        
//        if indexPath.row==4
//        {
//            cell.textLabel?.text = (NSString(format: "%@", id.getProperty("created") as! CVarArg) as String)
//            cell.detailTextLabel?.text=" Joined"
//            
//            
//        }
//        
//        if indexPath.row==5
//        {
//            // cell.textLabel?.text = (NSString(format: "%@", id.getProperty("lastLogin") as! CVarArg) as String)
//            cell.detailTextLabel?.text=" Last Login"
//            
//            
//        }
        
        // cell.textLabel?.text = "index -- \((indexPath as NSIndexPath).row)"
        cell.detailTextLabel?.textColor=UIColor.lightGray
        return cell
    }
    
    
    class CustomTableViewCell: UITableViewCell {
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        // Here you can customize the appearance of your cell
        override func layoutSubviews() {
            super.layoutSubviews()
            // Customize imageView like you need
            self.imageView?.frame = CGRect(x:10,y:0,width :40, height :40)
            self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            // Costomize other elements
            self.textLabel?.frame = CGRect(x:60, y:0, width:  self.frame.width - 45,  height:20)
            self.detailTextLabel?.frame = CGRect(x:60, y:20,  width :self.frame.width - 45, height: 15)
        }
    }
    
    
    
    
    class UIOutlinedLabel: UILabel {
        
        var outlineWidth: CGFloat = 1
        var outlineColor: UIColor = UIColor.black
        
        override func drawText(in rect: CGRect) {
            
            let strokeTextAttributes = [
                NSStrokeColorAttributeName : outlineColor,
                NSStrokeWidthAttributeName : -4 * outlineWidth,
                ] as [String : Any]
            
            self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
            super.drawText(in: rect)
        }
        //  self.view.frame.
    }
    
    
    private func rate(_ rating: Double) {
        
        var numberofRating : Double = self.id.nrating
        var ratings : Double = self.id.rating
        
        var  rated : String  = ""
        if  SMNavigationController.users.rated != ""
        {
            rated = SMNavigationController.users.rated
            
        }
        else
        {
            rated = "a"
            
            
        }
        let ResultString = "\(rated)\(self.id.email)"
        ratings+=rating
        numberofRating+=1;
        
//        self.id.setProperty("nrating", object: numberofRating)
//        self.id.setProperty("rating", object: ratings)
        
        self.id.nrating = numberofRating
        self.id.rating = ratings
        
        _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: SMNavigationController.users.email).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.itemsUser.append(EntityUser(snap: snap))
                    print("NNNNNNNNNNNN")
                    self.del = snap.key 
                    print(self.del)
                    
                    _ =  FIRDatabase.database().reference(withPath: "users").child(self.del).updateChildValues(["rated": ResultString])
//                      _ =  FIRDatabase.database().reference(withPath: "users").child(self.del).updateChildValues(["rating": ratings])
//                      _ =  FIRDatabase.database().reference(withPath: "users").child(self.del).updateChildValues(["nrating": numberofRating])
                    SMNavigationController.users.rated = ResultString
                    _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: self.id.email).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for snap in snapshots {
                                self.itemsUserres.append(EntityUser(snap: snap))
                                print("NNNNNNNNNNNN")
                                self.delresultat = snap.key
                                print(self.delresultat)
                                
                                
        _ =  FIRDatabase.database().reference(withPath: "users").child(self.delresultat).updateChildValues(["rating": ratings])
          _ =  FIRDatabase.database().reference(withPath: "users").child(self.delresultat).updateChildValues(["nrating": numberofRating])
                                
                                
                                
                            }
                            //
                            
                            
                        }
                    })
                    
                    
                    
                    
                }
                //
                
                
            }
        })
        
        
        
        
        
        
        
        
        
//        self.backendless?.userService.currentUser.setProperty("rated", object: ResultString )
//        
//        
//        let dataStore = Backendless.sharedInstance().data.of(BackendlessUser.ofClass())
//        var error: Fault?
//        
//        let updatedContact = dataStore?.save(self.id, fault: &error) as? BackendlessUser
//        if error == nil {
//            print("Contact has been updated: \(updatedContact!.objectId)")
//        }
//        else {
//            print("Server reported an error (2): \(String(describing: error))")
//        }
//        
//        let dataStore1 = Backendless.sharedInstance().data.of(BackendlessUser.ofClass())
//        var error1: Fault?
//        
//        let updatedContact1 = dataStore1?.save(self.backendless?.userService.currentUser, fault: &error1) as? BackendlessUser
//        if error1 == nil {
//            print("Contact has been updated: \(updatedContact1!.objectId)")
//        }
//        else {
//            print("Server reported an error (2): \(error1)")
//        }
//        
        self.rating.settings.updateOnTouch = false
        print(rating)
    }
    
    
    private func alert(_ rating: Double){
        let alert = UIAlertController(title: "Hey", message: " You have already rated this teacher ", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
}
