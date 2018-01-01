//
//  AppGlobals.swift
//  CustomShop
//
//  Created by Zarko Popovski on 5/14/17.
//  Copyright © 2017 VMSCloud. All rights reserved.
//

import UIKit

import DPDropDownMenu

class AppGlobals: NSObject {
    static let sharedInstance:AppGlobals = AppGlobals()
    
    var menuItems:[DPItem] = [DPItem]()
    var products:[ProductEntity] = [ProductEntity]()
    var news:[NewsEntity] = [NewsEntity]()

}
