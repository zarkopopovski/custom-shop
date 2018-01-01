//
//  NewsViewController.swift
//  CustomShop
//
//  Created by Zarko Popovski on 5/14/17.
//  Copyright © 2017 VMSCloud. All rights reserved.
//

import UIKit
import PMJSON
import SVProgressHUD

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var news:[NewsEntity] = AppGlobals.sharedInstance.news

    let isTesting:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.fetchAllNews()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell_Identifier = "Cell"
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Cell_Identifier, for: indexPath)
        
        let newsTitle:UILabel = cell.viewWithTag(101) as! UILabel
        let newsDate:UILabel = cell.viewWithTag(102) as! UILabel
        let newsBody:UILabel = cell.viewWithTag(103) as! UILabel
        
        let newsObject = self.news[indexPath.row]
        newsTitle.text = newsObject.newsTitle
        newsDate.text = newsObject.newsDate
        newsBody.text = newsObject.newsBody
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchAllNews() {
        SVProgressHUD.show(withStatus: "Loading")
        
        if !isTesting {
            ApiClient.sharedInstance.findLatestNews { (hasError, resultArray) in
                SVProgressHUD.dismiss()
                if !hasError {
                    AppGlobals.sharedInstance.news = resultArray
                    self.news = resultArray
                    self.newsTableView.reloadData()
                }
            }
        } else {
            SVProgressHUD.dismiss()
            
            let path =  Bundle.main.path(forResource: "test_data", ofType: "json")
            let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
            let jsonDataString = String(data: jsonData! as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            
            do {
                let jsonDataObject = try JSON.decode(jsonDataString!)
                let jsonDataArray = try jsonDataObject.getArray("data")
                
                if jsonDataArray.count > 0 {
                    var newsArray:[NewsEntity] = [NewsEntity]()
                    for i in 0 ..< (jsonDataArray.count) {
                        let newsDataObj = jsonDataArray[i]
                        let newsEntity:NewsEntity = NewsEntity()
        
                        newsEntity.newsID = try newsDataObj.getString("id")
                        newsEntity.newsTitle = try newsDataObj.getString("title")
                        newsEntity.newsBody = try newsDataObj.getString("body")
                        newsEntity.newsDate = try newsDataObj.getString("date")
                        
                        newsArray.append(newsEntity)
                    }
                    
                    AppGlobals.sharedInstance.news = newsArray
                    self.news = newsArray
                    self.newsTableView.reloadData()
                }
                
            } catch {
                print("Error:",error)
            }
            
        }
        
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
