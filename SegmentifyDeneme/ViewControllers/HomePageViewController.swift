//
//  HomePageViewController.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 19.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import UIKit

class HomePageViewController : UIViewController {
    
    var images : [String] = []
    var names : [String] = []
    var titles : [String] = []
    var prices : [Int] = []
    var oldPrices : [String] = []
    var productIds : [String] = []
    
    var recommendations : [RecommendationModel] = []
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendPageViewEvent()
    }
    
    func sendPageViewEvent() {
        SegmentifyManager.config(appkey: Constant.segmentifyAppKey, dataCenterUrl: Constant.segmentifyDataCenterUrl, subDomain: Constant.segmentifySubDomain)
        let obj = SegmentifyObject()
        obj.category = "Home Page"
        SegmentifyManager.sharedManager().setPageViewEvent(segmentifyObject: obj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
        //obj.subCategory = "Womenswear"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setProductInfos(products : [ProductModel]) {
        for product in products {
            self.productIds.append(product.productId!)
            self.titles.append(product.name!)
            self.images.append("https:" + product.image!)
            self.prices.append(product.price!)
            if(product.oldPriceText != nil){
                self.oldPrices.append(product.oldPriceText!)
            }
        }
        self.tableview.reloadData()
    }
    
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            print("rec obj : \(String(describing: recObj.notificationTitle))")
            print("rec obj : \(String(describing: recObj.products))")
            if recObj.notificationTitle == "Deneme" {
                self.setProductInfos(products: recObj.products!)
            }
        }
    }
}

extension HomePageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.nameLabel.text = self.titles[indexPath.row]
        cell.priceLabel.text = String(self.prices[indexPath.row])
        cell.oldPriceLabel.text=String(self.oldPrices[indexPath.row])
        
        cell.onButtonTapped = {
            print(self.productIds[indexPath.row])
            
            //SegmentifyManager.sharedManager(appKey: self.appKey, dataCenterUrl: self.dataCenterUrl, subDomain: self.subDomain).setAddOrRemoveBasketStepEvent(basketStep: "add", productID: self.productIds[indexPath.row], price: self.prices[indexPath.row] as NSNumber, quantity:1)
        }
        
        if let imageURL = URL(string:  self.images[indexPath.row]) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgDeneme.image = image
                    }
                }
            }
        }
        return cell
    }
}

