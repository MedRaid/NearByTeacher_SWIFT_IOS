 //
//  ChatVC.swift
//  NearByTeacher
//
//  Created by Raddaoui Mohamed Raid on 3/30/17.
//  Copyright © 2017 tn.esprit.NearByTeachers. All rights reserved.
//
 
 
 import UIKit
 import FirebaseAuth
 import  FirebaseDatabase
 import MobileCoreServices
 import FirebaseAuth
 import Firebase
 import SystemConfiguration

 import Kingfisher
 
 
 
import JSQMessagesViewController
import MobileCoreServices
//import AVKit
class ChatVC: JSQMessagesViewController {
    var items : [EntityUser] = [EntityUser] ()
    var msgs : [EntityMessage] = [EntityMessage] ()

    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil
    var valeur: String = "aa"
   
    private var messages = [JSQMessage]();
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
    
    
    func getUser(){
    
        
        
        
        
        if ( rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!) != nil ){
            print("user gooooot man")
            
            
            rootRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
             //   let em = snapshot.childSnapshot(forPath: "email").value as! String

                
              //  let url = URL(string: self.urlImage)
               // self.photoimageView.kf.setImage(with: url)
                
                
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snaps in snapshots {
                        self.items.append(EntityUser(snap: snaps))
                        
                        
                        
                        //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                    }
                    for i in 0...self.items.count-1 {
                        print("hahahahahahhahha")
                        //print(hismail)
                        
                        print(self.items[i].email)
                        print("hahahahhahah")
                        
                    }
//
                    
                    print("found")
                }
            }) { (error) in
                print("error no user")
                print(error.localizedDescription)
            }
            
            
            
                
                
            }
    }
    
    
    func getAllEvents()   {
        
        _ = FIRDatabase.database().reference(withPath: "messages").queryOrdered(byChild: "Receiver").queryEqual(toValue: SMNavigationController.users?.email).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.msgs.append(EntityMessage(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                for i in 0...self.msgs.count-1 {
                    print("zzzzzzzzzzz")
                    //print(hismail)
                    
                    print(self.msgs[i].message)
                    print("zzzzzzzzz")
                    
                }
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//self.senderDisplayName = "aa"
     self.senderDisplayName = SMNavigationController.users?.email
        self.senderId = SMNavigationController.users?.idd

        msgs = [EntityMessage]()

        _ = FIRDatabase.database().reference(withPath: "messages").queryOrdered(byChild: "Receiver").queryEqual(toValue: SMNavigationController.users?.email).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.msgs.append(EntityMessage(snap: snap))
                    
                    
                    
                    //  lblNom.text = snap.childSnapshot(forPath: "Sender").value as! String
                }
                if (self.msgs.count-1 >= 0){
                for i in 0...self.msgs.count-1 {
                    print("zzzzzzzzzzz")
                    //print(hismail)
                    
                    
                    self.messages.append(JSQMessage(senderId: "1", displayName: self.msgs[i].Receiver , text: self.msgs[i].message));

                    print(self.msgs[i].message)
                    print("zzzzzzzzz")
                    
                }
                    self.collectionView.reloadData();

                }
                else {}

            }
        
        
        
        
    })

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        
        let bubbleFactory = JSQMessagesBubbleImageFactory();
        let message = messages[indexPath.item];
        
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue);
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.darkGray);
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "usr"), diameter: 30)
    }
    
    
    //**************************************************************
    //end collection view fonctions
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text));
   
        
        
        /*************/
        let userItem = EntityMessage(Sender: senderDisplayName!,
                                  Receiver: valeur,
                                  message: text!)       // 3
        //   ts: ts!)       // 3
        
        
        let eventItemRef = self.rootRef.child("messages").childByAutoId()
        
        
        
        eventItemRef.setValue(userItem.toAnyObject())
        //self.performSegue(withIdentifier: "home", sender: self)
        /*************/
        
        
        
        
        
        collectionView.reloadData()
        
        
        //remove text from field
        finishSendingMessage()
    }
    func messageReceived(senderID: String, senderName: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text));
        collectionView.reloadData();
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
