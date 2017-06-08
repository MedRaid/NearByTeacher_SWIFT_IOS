

import UIKit
import FirebaseAuth
import  FirebaseDatabase
import MobileCoreServices
import FirebaseAuth
import Firebase
import SystemConfiguration
import Cosmos


class TeacherController: UITableViewController {
    var id:EntityUser = EntityUser();
    var header : StretchHeader!
    var indicator = UIActivityIndicatorView()
    var feedEmail : String = "a"
    var valeur : String = "a"
    let rootRef = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let ref: FIRDatabaseReference? = nil

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
        
        
        let rating=CosmosView();
        rating.frame = CGRect(x: header.frame.size.width / 4, y: header.frame.size.height - 100, width: header.frame.size.width , height: 10)
        
        rating.settings.updateOnTouch = false
        rating.settings.filledColor = UIColor.orange
        
        // Set the border color of an empty star
        rating.settings.emptyBorderColor = UIColor.orange
        
        // Set the border color of a filled star
        rating.settings.filledBorderColor = UIColor.orange
        rating.settings.starSize=20
        
        rating.settings.fillMode = .precise
        rating.settings.emptyBorderColor = UIColor.black
        
        // Set the border color of a filled star
        rating.settings.filledBorderColor = UIColor.black
        
        //rating.text="rating"
        rating.settings.starMargin=20
        let  tratin : Double =   id.rating
        let  nratin : Double =   id.nrating
        
        
      rating.rating=tratin/nratin
        //rating.rating=1

        let label = UIOutlinedLabel()
label.frame = CGRect( x: (self.view.frame.width / 6) - 20 , y: header.frame.size.height - 75, width: (header.frame.size.width / 2 ) + 90 , height: 35)
        label.textColor = UIColor.white
        label.text = id.Firstname
        label.backgroundColor = UIColor.gray
       // label.center = CGPoint(x: (self.view.frame.width / 6) , y: header.frame.size.height - 85)
        label.textAlignment = NSTextAlignment.center

        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        
     
     
        //btn 2
        let button1 = UIButton(frame: CGRect(x: 0 , y: header.frame.size.height - 35, width: (header.frame.size.width / 3 )   , height: 28))
        button1.backgroundColor = UIColor(hexString: "F0A761")
        button1.setTitle("Text", for: UIControlState.normal)
        button1.addTarget(self, action: #selector(goMessage), for: .touchUpInside)
        
        //btn 3
        let button2 = UIButton(frame: CGRect(x: (header.frame.size.width / 3 )  , y: header.frame.size.height - 35, width: (header.frame.size.width / 3 )  , height: 28))
        button2.backgroundColor = UIColor(hexString: "FEC362")
        button2.setTitle("Feeds", for: UIControlState.normal)

        button2.addTarget(self, action: #selector(goFeeds), for: .touchUpInside)
        
        //btn 4
        let button3 = UIButton(frame: CGRect(x: (self.view.frame.width * 2) / 3 , y: header.frame.size.height - 35, width: (header.frame.size.width / 3 ) , height: 28))
        button3.backgroundColor = UIColor(hexString: "F0A761")
        button3.setTitle("Give Feed", for: UIControlState.normal)

        button3.addTarget(self, action: #selector(SendFeed), for: .touchUpInside)
        
        
        header.addSubview(label)
        header.addSubview(rating)
        header.addSubview(button1)
        header.addSubview(button2)
        header.addSubview(button3)

        tableView.tableHeaderView = header
    }

    func goMessage() {
        print("Button pressed")
        let vc = ChatVC()
        vc.valeur=id.email
        self.navigationController?.pushViewController(vc, animated: true)

       // self. pushViewController(vc, animated: true)
    }
    func goFeeds() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "teatfeeds")
           as! FeedBacksController
        controller.feedEmail = id.email
        self.show(controller, sender: self)
        


    }
    func SendFeed() {
        let alert = UIAlertController(title: "Write Your FeedBack", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            let userItem = EntityFeed(Sender: SMNavigationController.users.email,
                                      Receiver: self.id.email,
                                      message: (textField?.text!)!)       // 3
            //   ts: ts!)       // 3
            let eventItemRef = self.rootRef.child("Feed").childByAutoId()
            eventItemRef.setValue(userItem.toAnyObject())
            
            
            let alert = UIAlertController(title: "Guess What", message: "Sucessfully Added", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    
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
                cell.detailTextLabel?.text = " "+(NSString(format: "%@", id.price as CVarArg) as String)+"$" as String
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
//extension UIColor {
//    convenience init(hexString: String) {
//        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int = UInt32()
//        Scanner(string: hex).scanHexInt32(&int)
//        let a, r, g, b: UInt32
//        switch hex.characters.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (255, 0, 0, 0)
//        }
//        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
//    }
//}
//
