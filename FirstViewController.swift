//
//  FirstViewController.swift
//  TableViewSIM22017
//
//  Created by Raddaoui Mohamed Raid on 3/1/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet var lab: UILabel!
    var valeur:String = ""
    
    @IBOutlet var sangour: UISegmentedControl!
    
    
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
    
    @IBAction func indaxes(_ sender: Any) {
        
        switch sangour.selectedSegmentIndex
        {
        case 0:
            lab.text = "bmw";
            
        case 1:
            lab.text = "mercedes";
        case 2:
            lab.text = "clio";
            
        default:
            break;
        }
        valeur=lab.text!
        
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == "lista" {
////            let svc : ViewController = segue.destination as! ViewController
////            svc.valeur = sender as! String
////            
////        }
//    }
    
    @IBAction func bot(_ sender: Any) {
        
        performSegue(withIdentifier: "lista", sender: valeur )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
