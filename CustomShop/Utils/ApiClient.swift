//
//  ApiClient.swift
//  CustomShop
//
//  Created by Zarko Popovski on 5/14/17.
//  Copyright © 2017 VMSCloud. All rights reserved.
//

import UIKit

import Alamofire

import PMJSON

class ApiClient: NSObject {
    static let sharedInstance:ApiClient = ApiClient()
    
    let BASE_URL = "http://localhost:8080"
    
    let API_LIST_NEWS = "/list_news"
    let API_LIST_PRODUCTS = "/index.php/customer/view_customer_products"
    
    func findProductsByCategory(categoryName:String, completition:@escaping (Bool, [ProductEntity]) -> ()) {
        let apiParams:[String:String] = ["random_products":"1", "page":"1"]
        
        Alamofire.request(BASE_URL+""+API_LIST_PRODUCTS, method: .post, parameters:apiParams).responseString(completionHandler: { (response) in
        
            let stringResponse = response.result.value!
            
            var jsonData:JSON
            
            do
            {
                jsonData = try JSON.decode(stringResponse)
                
                let resultArray = try jsonData.getArray("data")
                
                    if resultArray != nil {
                        
                        var productsArray:[ProductEntity] = [ProductEntity]()
                        
                        for i in 0 ..< (resultArray.count) {
                            let productDataObj = resultArray[i]
                            
                            let productEntity:ProductEntity = ProductEntity()
                            
                            productEntity.productID = try productDataObj.getString("id")
                            productEntity.productCategory = try productDataObj.getString("cat_name")
                            productEntity.productName = try productDataObj.getString("product_name")
                            productEntity.productDescription = try productDataObj.getString("description")
                            productEntity.productPrice = try productDataObj.getString("output_price")
                            productEntity.productMedia = try productDataObj.getString("media")
                            
                            productsArray.append(productEntity)
                        }
                        completition(false, productsArray)
                    } else {
                        print("No Data")
                        completition(true, [])
                    }
                    
                }
            catch
            {
                print("Error:",error)
            }
            
        })
    }
    
    func findLatestNews(completition:@escaping(Bool,[NewsEntity])->()) {
        Alamofire.request(BASE_URL+""+API_LIST_NEWS, method: .post, parameters:nil).responseString(completionHandler: { (response) in
            
            let stringResponse = response.result.value!
            
            var jsonData:JSON
            
            do
            {
                jsonData = try JSON.decode(stringResponse)
                
                let resultArray = try jsonData.getArray("data")
                
                if resultArray != nil {
                    
                    var newsArray:[NewsEntity] = [NewsEntity]()
                    
                    for i in 0 ..< (resultArray.count) {
                        let newsDataObj = resultArray[i]
                        
                        let newsEntity:NewsEntity = NewsEntity()
                        
                        newsEntity.newsID = try newsDataObj.getString("id")
                        newsEntity.newsTitle = try newsDataObj.getString("title")
                        newsEntity.newsBody = try newsDataObj.getString("body")
                        newsEntity.newsDate = try newsDataObj.getString("date")
                        
                        newsArray.append(newsEntity)
                    }
                    completition(false, newsArray)
                } else {
                    print("No Data")
                    completition(true, [])
                }
                
            }
            catch
            {
                print("Error:",error)
            }
            
        })
    }
    
    
}
