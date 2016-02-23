//
//  PrdouctMenuTableViewCell.swift
//  FilterDemo
//
//  Created by juanmao on 16/1/29.
//  Copyright © 2016年 juanmao. All rights reserved.
//

import UIKit

let screenHeight = UIScreen.mainScreen().bounds.height
let screenWidth  = UIScreen.mainScreen().bounds.width
    ///添加和删除按钮共用一个闭包，实际项目中最好分开定义两个闭包，并且传入model对象
class PrdouctMenuTableViewCell: UITableViewCell {
    var productName:UILabel!
    var minusBtn:UIButton!
    var plusBtn:UIButton!
    var buyCount:UILabel!
    var separateLine:UIView?
        ///实际项目中此处应该传model
    var productNameStr:String?
        ///声明闭包
    var addProClosure:((UITableViewCell,Bool)->())?

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.productName = UILabel(frame:CGRectMake(15,15,(screenWidth*0.7) - 30,20))
        self.productName.font = UIFont.systemFontOfSize(15)
        self.productName.textColor = UIColor.blackColor()
        self.productName.textAlignment = NSTextAlignment.Left
        self.contentView.addSubview(self.productName)
        
        self.plusBtn = UIButton(type: UIButtonType.Custom)
        self.plusBtn.frame =  CGRectMake((screenWidth*0.7) - 59,36,44,44)
        self.plusBtn.setImage(UIImage(named: "btn_increase"), forState: UIControlState.Normal)
        self.plusBtn.addTarget(self, action: "plusBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.plusBtn)
        
        self.separateLine = UIView(frame:CGRectMake(0,85-0.5,screenWidth*0.7,0.5))
        self.separateLine?.backgroundColor = UIColor.grayColor()
        self.contentView.addSubview(self.separateLine!)
        
        
        self.minusBtn = UIButton(type: UIButtonType.Custom)
        self.minusBtn.frame =  CGRectMake((screenWidth*0.7) - 59,36,44,44)
        self.minusBtn.setImage(UIImage(named: "btn_decrease"), forState: UIControlState.Normal)
        self.minusBtn.addTarget(self, action: "minusBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.minusBtn)
        
        self.buyCount = UILabel(frame: CGRectMake((screenWidth*0.7) - 59,36,44,44))
        self.buyCount.font = UIFont.systemFontOfSize(13)
        self.buyCount.textColor = UIColor.blackColor()
        self.buyCount.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(self.buyCount)
        
        self.contentView.bringSubviewToFront(self.plusBtn)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.productName.text = self.productNameStr
    }
    
    func plusBtnClick(btn:UIButton){
        let point:CGPoint = self.convertPoint(btn.frame.origin, toView: (UIApplication.sharedApplication().delegate?.window)!)
        let circleView:UIView = UIView(frame:CGRectMake(point.x,point.y,20,20))
        circleView.layer.cornerRadius = btn.frame.width / 2
        circleView.backgroundColor = UIColor.blueColor()
        let window:UIWindow! = (UIApplication.sharedApplication().delegate?.window)!
        window.addSubview(circleView)
        let keyframeAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        let path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, circleView.layer.position.x, circleView.layer.position.y)
        CGPathAddQuadCurveToPoint(path, nil, 100, circleView.layer.position.y+50, 30, screenHeight-30)
        keyframeAnimation.path = path
        keyframeAnimation.delegate = self
        keyframeAnimation.duration = 0.5
        circleView.layer.addAnimation(keyframeAnimation, forKey: "position");
        circleView.performSelector("removeFromSuperview", withObject: nil, afterDelay: 0.45)
        
            ///实际项目中此处应加上对库存的判断
        if self.buyCount.text == nil
        {
            UIView.animateWithDuration(0.5) { () -> Void in
                self.minusBtn.frame.origin.x = (screenWidth*0.7) - 157
                self.buyCount.frame.origin.x = (screenWidth*0.7) - 108
                self.minusBtn.alpha = 1.0
                self.buyCount.text = "1"
            }
        }
        else
        {
            self.buyCount.text = String(Int(self.buyCount.text!)!+1)
        }
        if addProClosure != nil
        {
            addProClosure!(self,true)
        }
    }
    
    func minusBtnClick(btn:UIButton)
    {
            ///实际项目中此处应加上对库存的判断
        if Int(self.buyCount.text!) > 1
        {
            self.buyCount.text = String(Int(self.buyCount.text!)!-1)
        }
        else
        {
            UIView.animateWithDuration(0.5) { () -> Void in
                self.minusBtn.frame.origin.x = (screenWidth*0.7) - 59
                self.buyCount.frame.origin.x = (screenWidth*0.7) - 59
                self.minusBtn.alpha = 0.0
                self.buyCount.text = nil
            }
        }
        if addProClosure != nil
        {
            addProClosure!(self,false)
        }
    }
}
