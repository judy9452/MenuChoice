//
//  ViewController.swift
//  MenuChoice
//
//  Created by juanmao on 16/2/16.
//  Copyright © 2016年 juanmao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var productTypeArr:[String] = []
    var productNameArr:[AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "举个🌰"
        self.view.backgroundColor = UIColor.whiteColor()
        self.initData()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func  initData()
    {
        let path:String = (NSBundle.mainBundle().pathForResource("MenuData", ofType: "json"))!
        let data:NSData = NSData(contentsOfURL: NSURL(fileURLWithPath: path))!
        let json:AnyObject = try!NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        let resultDict = json.objectForKey("data") as! Dictionary<String,AnyObject>
        let productMenuArr:[AnyObject] = resultDict["productType"] as! Array
        for var i:Int = 0;i < productMenuArr.count; i++
        {
            productTypeArr.append(productMenuArr[i]["typeName"] as! String)
            productNameArr.append(productMenuArr[i]["productName"] as! [String])
        }
        
        self.addSubView()
    }

    
    func addSubView(){
            ///调用时传入frame和数据源
        let classifyTable = GroupTableView(frame: CGRectMake(0,64,screenWidth,screenHeight-64), MenuTypeArr: productTypeArr, proNameArr: productNameArr)
        self.view.addSubview(classifyTable)
    }

}

