//
//  GroupTableView.swift
//  FilterDemo
//
//  Created by juanmao on 16/1/25.
//  Copyright © 2016年 juanmao. All rights reserved.
//

import UIKit

class GroupTableView: UIView,UITableViewDelegate,UITableViewDataSource {
    var groupTableView:UITableView!
    var classifyTableView:UITableView!
    var productTypeArr:[String] = []
    var productNameArr:[AnyObject] = []
    var currentExtendSection:Int = 0
    var isScrollSetSelect = false
    var isScrollClassiftyTable = false
    
    init(frame:CGRect, MenuTypeArr:[String], proNameArr:[AnyObject]) {
        super.init(frame: frame)
        self.initData()
        self.groupTableView = UITableView(frame: CGRectMake(frame.width*0.3, 0, frame.width*0.7, frame.height), style: UITableViewStyle.Plain)
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        self.groupTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.groupTableView.tableHeaderView?.backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
        self.addSubview(self.groupTableView)
        
        self.classifyTableView = UITableView(frame:CGRectMake(0, 0, frame.width*0.3, frame.height),style:UITableViewStyle.Plain)
        self.classifyTableView.delegate = self;
        self.classifyTableView.dataSource = self;
        self.classifyTableView.tableFooterView = UIView()
        self.addSubview(self.classifyTableView)
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    }
    
        //MARK:UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.classifyTableView
        {
            return productTypeArr.count
        }
        else
        {
            return productNameArr[section].count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let classifyCell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "classifyCell")
        let extendCell:PrdouctMenuTableViewCell = PrdouctMenuTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "extendCell")
        extendCell.backgroundColor = UIColor(red: 238, green: 238, blue: 238, alpha: 1);
        if tableView == self.classifyTableView
        {
            classifyCell.textLabel?.text = self.productTypeArr[indexPath.row]
            classifyCell.textLabel?.numberOfLines = 0
            classifyCell.backgroundColor = UIColor(red: 238, green: 238, blue: 238, alpha: 1)
            classifyCell.selectionStyle = UITableViewCellSelectionStyle.None
            if indexPath.row == currentExtendSection
            {
                let tempView:UIView = UIView(frame:CGRectMake(0,0,5,55))
                tempView.tag = 101
                tempView.backgroundColor = UIColor.redColor()
                classifyCell.addSubview(tempView)
            }
            return classifyCell
        }
        else
        {
            if productNameArr[indexPath.section].count > indexPath.row
            {
                extendCell.productNameStr = productNameArr[indexPath.section].objectAtIndex(indexPath.row) as? String
            }
            extendCell.addProClosure = {(cell:UITableViewCell,isAddProduct:Bool) in
                let indexPath:NSIndexPath = (self.groupTableView.indexPathForCell(cell))!
                let cell:UITableViewCell = self.classifyTableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.section, inSection: 0))!
                var buyCountLab:UILabel? = cell.viewWithTag(200) as? UILabel
                if buyCountLab == nil
                {
                    buyCountLab = UILabel(frame:CGRectMake(cell.frame.width-20,5,15,15))
                    buyCountLab?.backgroundColor = UIColor.redColor()
                    buyCountLab?.textColor = UIColor.whiteColor()
                    buyCountLab?.textAlignment = NSTextAlignment.Center
                    buyCountLab?.font = UIFont.systemFontOfSize(10)
                    buyCountLab?.tag = 200
                    buyCountLab?.text = "1"
                    cell.addSubview(buyCountLab!)
                }
                else
                {
                    if isAddProduct == true
                    {
                        buyCountLab?.text = String(Int((buyCountLab?.text)!)!+1)
                    }
                    else
                    {
                        if Int((buyCountLab?.text)!) > 1
                        {
                            buyCountLab?.text = String(Int((buyCountLab?.text)!)!-1)
                        }
                        else
                        {
                            buyCountLab?.removeFromSuperview()
                        }
                    }
                }
                
                print(indexPath.section)
            }
            return extendCell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if tableView == self.groupTableView
        {
            return productTypeArr.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section:
        Int) -> String?
    {
        if tableView == groupTableView
        {
            return productTypeArr[section]
        }
        return ""
    }
        //MARK:UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if tableView == self.classifyTableView
        {
            return 55
        }
        else
        {
            return 85
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == groupTableView
        {
            return 30
        }
        return 0.1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if tableView == self.classifyTableView
        {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.leftSectionSelected(indexPath, withTableView: tableView,didSelectClassifyTable:true)
        }
    }
    
    func leftSectionSelected(indexPath:NSIndexPath, withTableView tableView:UITableView,didSelectClassifyTable:Bool)
    {
        if tableView == self.classifyTableView
        {
            if indexPath.row == currentExtendSection
            {
                return ;
            }
            let newCell:UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
            let tempView:UIView = UIView(frame:CGRectMake(0,0,5,55))
            tempView.tag = 101
            tempView.backgroundColor = UIColor.redColor()
            newCell?.addSubview(tempView)
            
            let oldIndexPath:NSIndexPath = NSIndexPath(forRow: currentExtendSection, inSection: 0)
            let oldCell:UITableViewCell? = tableView.cellForRowAtIndexPath(oldIndexPath)
            let view:UIView? = oldCell?.viewWithTag(101)
            view? .removeFromSuperview()
            
             self.currentExtendSection = indexPath.row
            
            self.groupTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection:self.currentExtendSection), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            isScrollClassiftyTable = didSelectClassifyTable
            
            let cellR:CGRect = self.classifyTableView.rectForRowAtIndexPath(indexPath)
            if self.classifyTableView.contentOffset.y - cellR.origin.y > 54
            {
                self.classifyTableView.contentOffset.y = CGFloat(55 * indexPath.row)
            }
        }

    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        isScrollSetSelect = false
        if scrollView == self.groupTableView
        {
            isScrollSetSelect = true
            isScrollClassiftyTable = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView == self.groupTableView && isScrollSetSelect && isScrollClassiftyTable == false
        {
            let indexPathArr:[NSIndexPath]? =  self.groupTableView.indexPathsForVisibleRows
            self.leftSectionSelected(NSIndexPath(forRow:indexPathArr![0].section, inSection: 0), withTableView: self.classifyTableView,didSelectClassifyTable: false)
        }
    }
}
