

import UIKit
import SystemConfiguration

import Cosmos


class StudentController: UITableViewController {
    var id:EntityUser = EntityUser();
    var header : StretchHeader!
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
        //  tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        setupHeaderView()
    }
    
    func setupHeaderView() {
        
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 360),
                                 imageSize: CGSize(width: view.frame.size.width, height: 260),
                                 controller: self,
                                 options: options)
        do {
            header.imageView?.sd_setImage(with: URL(string: id.urlImage as! String), placeholderImage: UIImage(named: "school.jpg"))
        }
        catch{
            
            header.imageView.image = #imageLiteral(resourceName: "school")
            
            
        }
        
        
        
        // custom
        
        
//        let rating=CosmosView();
//        rating.frame = CGRect(x: header.frame.size.width / 4, y: header.frame.size.height - 100, width: header.frame.size.width , height: 10)
//        
//        rating.settings.updateOnTouch = false
//        rating.settings.filledColor = UIColor.orange
//        
//        // Set the border color of an empty star
//        rating.settings.emptyBorderColor = UIColor.orange
//        
//        // Set the border color of a filled star
//        rating.settings.filledBorderColor = UIColor.orange
//        rating.settings.starSize=20
//        
//        rating.settings.fillMode = .precise
//        rating.settings.emptyBorderColor = UIColor.black
//        
//        // Set the border color of a filled star
//        rating.settings.filledBorderColor = UIColor.black
//        
//        //rating.text="rating"
//        rating.settings.starMargin=20
//        let  tratin : Double =   id.rating
//        let  nratin : Double =   id.nrating
        
        
       // rating.rating=tratin/nratin
        //rating.rating=1
        
        let label = UIOutlinedLabel()
        label.frame = CGRect( x: (self.view.frame.width / 6) - 20 , y: header.frame.size.height - 75, width: (header.frame.size.width / 2 ) + 90 , height: 35)
        label.textColor = UIColor.white
        label.text = id.Firstname 
        label.backgroundColor = UIColor.gray
        // label.center = CGPoint(x: (self.view.frame.width / 6) , y: header.frame.size.height - 85)
        label.textAlignment = NSTextAlignment.center
        
        label.font = UIFont.boldSystemFont(ofSize: 18)
        header.addSubview(label)
       // header.addSubview(rating)
        
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
        return 4    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        
        if indexPath.row==0
        {
            cell.textLabel?.text = " Phone number"
            cell.detailTextLabel?.text = " "+id.phone as String?
            cell.imageView?.image = UIImage(named: "phones");
            cell.detailTextLabel?.textColor=UIColor.lightGray
            
            
        }
        
        
        if indexPath.row==1
        {
            
            cell.textLabel?.text = " Email"
            cell.detailTextLabel?.text = " "+id.email as String?
            cell.imageView?.image = UIImage(named: "em");
            cell.detailTextLabel?.textColor=UIColor.lightGray
            
            
        }
        
        
        if indexPath.row==2
        {
            
            if (id.spec != "")
                
            {
                cell.textLabel?.text = " Teacher Speciality"
                cell.detailTextLabel?.text = " "+id.spec as String?
                cell.imageView?.image = UIImage(named: "spec4");
                cell.detailTextLabel?.textColor=UIColor.lightGray}
        }
        
        if indexPath.row==3
        {
            if (id.price != "")
                
            {
                cell.textLabel?.text = " Price Per Session"
                cell.detailTextLabel?.text = " "+(NSString(format: "%@", id.price as! CVarArg) as String)+"$" as String
                cell.imageView?.image = UIImage(named: "money");
                cell.detailTextLabel?.textColor=UIColor.lightGray}
            else {print("mahnech")}
        }
        //
        
        
        
        //        if indexPath.row==4
        //        {
        //         //   cell.textLabel?.text = (NSString(format: "%@", id.getProperty("created") as! CVarArg) as String)
        //            cell.textLabel?.text = "zzzzz" as String
        //
        //            cell.detailTextLabel?.text=" Joined"
        //
        //
        //        }
        //
        //        if indexPath.row==5
        //        {
        ////            cell.textLabel?.text = (NSString(format: "%@", id.getProperty("lastLogin") as! CVarArg) as String)
        //            cell.textLabel?.text = "zzzz2" as String
        //
        //            cell.detailTextLabel?.text=" Last Login"
        //
        //
        //        }
        
        // cell.textLabel?.text = "index -- \((indexPath as NSIndexPath).row)"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 0)
        {
            //        if let phoneCallURL:URL = URL(string: "tel:\(id.phone)") {
            //            let application:UIApplication = UIApplication.shared
            //            if (application.canOpenURL(phoneCallURL)) {
            //                let alertController = UIAlertController(title: "MyApp", message: "Are you sure you want to call \n\(self.id.phone)?", preferredStyle: .alert)
            //                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //                    application.openURL(phoneCallURL)
            //                })
            //                let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
            //
            //                })
            //                alertController.addAction(yesPressed)
            //                alertController.addAction(noPressed)
            //                present(alertController, animated: true, completion: nil)
            //            }
            //        }
            guard let number = URL(string: "telprompt://" + id.phone) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
            
            
        }
        
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
