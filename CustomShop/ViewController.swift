//
//  ViewController.swift
//  CustomShop
//
//  Created by Zarko Popovski on 5/6/17.
//  Copyright © 2017 VMSCloud. All rights reserved.
//

import UIKit

import DPDropDownMenu
import SVProgressHUD
import SDWebImage

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var productsMenu: DPDropDownMenu!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var selectedCategoryIndex:Int = 0
    
    var products:[ProductEntity] = AppGlobals.sharedInstance.products
    
    let imagesURL = "http://207.154.254.209/scapi/uploads/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupCategoriesMenu();
        refreshProductsData();
    }
    
    func loadProductCategories() -> [DPItem] {
        var menuItems:[DPItem] = [DPItem]()
        
        menuItems = [DPItem(title: "Vehicles"),
                     DPItem(title: "Properties"),
                     DPItem(title: "Home and Garden"),
                     DPItem(title: "Mode"),
                     DPItem(title: "Mobile Phones"),
                     DPItem(title: "Computers"),
                     DPItem(title: "HiFi")]
        let menuCodes:[String] = ["T001","T017","T031","T054","T067","T073","T083"]
        
        AppGlobals.sharedInstance.menuItems = menuItems
        
        return menuItems
    }
    
    func refreshProductsData() {
        SVProgressHUD.show(withStatus: "Loading")
        ApiClient.sharedInstance.findProductsByCategory(categoryName: AppGlobals.sharedInstance.menuItems[self.selectedCategoryIndex].title) { (status, products) in
            SVProgressHUD.dismiss()
            if !status {
                AppGlobals.sharedInstance.products = products
                
                self.products = products
                
                self.productsCollectionView.reloadData()
            }
        }
    }
    
    func setupCategoriesMenu() {
        self.productsMenu.items = self.loadProductCategories()
        
        self.productsMenu.didSelectedItemIndex = { index in
            print("did selected index: \(index)")
            self.selectedCategoryIndex = index
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell_Identifier = "Cell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell_Identifier, for: indexPath)
        
        let cellData = self.products[indexPath.row]
        
        let imageView:UIImageView = cell.viewWithTag(100) as! UIImageView
        let labelTitle:UILabel = cell.viewWithTag(101) as! UILabel
        let labelPrice:UILabel = cell.viewWithTag(102) as! UILabel
        
        imageView.sd_setImage(with: URL(string: self.imagesURL+""+cellData.productMedia), completed: { (image, error, imageCacheType, url) in
            
        })

        labelTitle.text = cellData.productName
        labelPrice.text = cellData.productPrice + "€"
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let Cell_Identifier = "Cell"
        
        let selectedProduct:ProductEntity = self.products[indexPath.row]
        
        let productDetails:ProductDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
        productDetails.product = selectedProduct
        
        self.navigationController?.pushViewController(productDetails, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

