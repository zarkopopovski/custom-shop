//
//  ProductDetailsViewController.swift
//  CustomShop
//
//  Created by Zarko Popovski on 5/14/17.
//  Copyright © 2017 VMSCloud. All rights reserved.
//

import UIKit
import MessageUI

class ProductDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var product:ProductEntity? = nil
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescription: UITextView!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnMail: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    let imagesURL = "http://207.154.254.209/scapi/uploads/"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.productImageView.sd_setImage(with: URL(string: self.imagesURL+""+(self.product?.productMedia)!), completed: { (image, error, imageCacheType, url) in
            
        })
        
        self.lblTitle.text = self.product?.productName
        self.lblPrice.text = (self.product?.productPrice)! + "€"
        self.productDescription.text = self.product?.productDescription

    }

    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareAction(_ sender: UIButton) {
        let textToShare = "Check this \(self.product?.productCode) super product at MyShop. "
        
        if let myWebsite = NSURL(string: "http://www.myshop.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.postToFacebook, UIActivityType.postToTwitter]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnMainAction(_ sender: UIButton) {
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setToRecipients(["interested@myshop.com"])
            mailComposer.setSubject("Interested in product \(self.product?.productCode) " )
            mailComposer.setMessageBody("Dear Shop...", isHTML: false)
            
            self.present(mailComposer, animated: true, completion: nil)
        } else {
            let alert:UIAlertController = UIAlertController(title: "Error", message: "Error sending email", preferredStyle: .alert)
            let alertCloseAction = UIAlertAction(title: "Close", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(alertCloseAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
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
