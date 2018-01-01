//
//  ProductEntity.swift
//  CustomShop
//
//  Created by Zarko Popovski on 5/14/17.
//  Copyright © 2017 VMSCloud. All rights reserved.
//

import UIKit

class ProductEntity: NSObject {
    var productID:String = ""
    var productCode:String = ""
    var productCategory:String = ""
    var productName:String = ""
    var productDescription:String = ""
    var productPrice:String = "0.0"
    var productTax:String = "0.0"
    var productAction:Bool = false
    var productActionPrice:String = "0.0"
    var productMedia:String = ""
    var productImages:[ProductImageEntity] = [ProductImageEntity]()
}
