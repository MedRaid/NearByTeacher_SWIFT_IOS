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
import Kingfisher

import Cosmos

class MyTeachersViewController: UITableViewController {
    var items : [EntityRequest] = [EntityRequest] ()
    var itemsaf : [EntityRequest] = [EntityRequest] ()
    
    var itemsUser : [EntityUser] = [EntityUser] ()
    var itemsUsera : [EntityRequest] = [EntityRequest] ()
    var itemsUsers : [EntityRequest] = [EntityRequest] ()
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var hismail = FIRAuth.auth()?.currentUser?.email
    var header : StretchHeader!
    
    var teachers:  [Requestsi] = [] ;
    var indicator = UIActivityIndicatorView()

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
    
            
            
            items = [EntityRequest]()
            
            itemsaf = [EntityRequest]()
            itemsUser = [EntityUser]()
            itemsUsera = [EntityRequest]()
            itemsUsers = [EntityRequest]()
            
            getAllEvents()
            
            
            
         
        //  tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        setupHeaderView()
    }
        
        func getAllEvents()   {
            print("lanana1")
            
            _ = FIRDatabase.database().reference(withPath: "requests").queryOrdered(byChild: "Sender").queryEqual(toValue: hismail).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        self.items.append(EntityRequest(snap: snap))
                        
                        
                        
                    }
                    var j = 0
                    if (self.items.count-1 > 0){
                        for i in 0...self.items.count-1
                        {
                            
                            
                            if (self.items.count-1 > 0)
                            {
                                if (self.items[i].status == "1"){
                                    print("zzzzzzzzzzz")
                                    
                                    self.itemsaf.insert(self.items[i], at: j)
                                    print("KKKKKKKK")
                                    print(self.itemsaf[j].Receiver)
                                    
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
                            
                            let alert = UIAlertController(title: "Guess What", message: "No pending requests for the moment", preferredStyle: UIAlertControllerStyle.alert)
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                            
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)}
                        
                        print("lanana2")
                        
                    }
                    
                    if (self.items.isEmpty){
                        
                        let alert = UIAlertController(title: "Check", message: "No Enrolments Yet With Any Teacher", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                        
                        DispatchQueue.main.async(execute: {
                            self.present(alert, animated: true, completion: nil)
                        })
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    //self.tableView.reloadData()
                    
                    
                }
                self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
        }
    
    func setupHeaderView() {
        
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        
        
        
        
        header.imageView.image = #imageLiteral(resourceName: "apple")
        
        
        
        // custom
        
        let label = UIOutlinedLabel()
        label.frame = CGRect( x: 10, y: header.frame.size.height - 40, width: header.frame.size.width - 20, height: 40)
        label.textColor = UIColor.white
        label.text = " My Teachers "
        label.font = UIFont.boldSystemFont(ofSize: 24)
        header.addSubview(label)
        
        
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
        return itemsaf.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        _ = FIRDatabase.database().reference(withPath: "users").queryOrdered(byChild: "email").queryEqual(toValue: self.itemsaf[indexPath.row].Receiver).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotss = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshotss {
                    self.itemsUser.append(EntityUser(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                for i in 0...self.itemsUser.count-1 {
                    
                    print("HHHHHAHHAHAHAHAHAHAHHAHAHAH")
                    print(self.itemsUser[i].Firstname)
                    
                    
                    let url = URL(string: self.itemsUser[i].urlImage as! String)
                    cell.imageView?.kf.setImage(with: url)
                    //                    cell.imageView?.sd_setImage(with: URL(string: teachers [indexPath.row].Receiver?.getProperty("pic") as! String), placeholderImage: UIImage(named: "teat.png"))
                    print(self.items[i].Sender)
                    
                    
                }
                
                if (self.itemsUser.isEmpty){
                
                    let alert = UIAlertController(title: "Check", message: "No Enrolments Yet With Any Teacher", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                    
                    DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true, completion: nil)
                    })
                
                
                
                }
                
            }
            
            //  self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
        
        
        cell.textLabel?.text = itemsaf[indexPath.row].Receiver
        cell.detailTextLabel?.text = itemsaf[indexPath.row].daterequest
        //        do
        //        {
        //            cell.imageView?.sd_setImage(with: URL(string: teachers [indexPath.row].Receiver?.getProperty("pic") as! String), placeholderImage: UIImage(named: "teat.png"))
        //        }
        //        catch {
        //
        //        }
        
        
        // cell.textLabel?.text = "index -- \((indexPath as NSIndexPath).row)"
        cell.imageView?.image=#imageLiteral(resourceName: "face2");
        cell.detailTextLabel?.textColor=UIColor.lightGray
        return cell
    }
    
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ConnectionCheck.isConnectedToNetwork() { }
        else{
            let alert = UIAlertController(title: "Check", message: "Internet Connection is Required ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })                }
        let tteacher = self.itemsUser[indexPath.row]
        let vc = MyTeacherDetailViewController()
        vc.id=tteacher
        self.navigationController?.pushViewController(vc, animated: true)
        
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
}
