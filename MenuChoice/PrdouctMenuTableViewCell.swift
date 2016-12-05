//
//  PrdouctMenuTableViewCell.swift
//  FilterDemo
//
//  Created by juanmao on 16/1/29.
//  Copyright © 2016年 juanmao. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let screenHeight = UIScreen.main.bounds.height
let screenWidth  = UIScreen.main.bounds.width
    ///添加和删除按钮共用一个闭包，实际项目中最好分开定义两个闭包，并且传入model对象
class PrdouctMenuTableViewCell: UITableViewCell,CAAnimationDelegate {
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
        self.productName = UILabel(frame:CGRect(x: 15,y: 15,width: (screenWidth*0.7) - 30,height: 20))
        self.productName.font = UIFont.systemFont(ofSize: 15)
        self.productName.textColor = UIColor.black
        self.productName.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(self.productName)
        
        self.plusBtn = UIButton(type: UIButtonType.custom)
        self.plusBtn.frame =  CGRect(x: (screenWidth*0.7) - 59,y: 36,width: 44,height: 44)
        self.plusBtn.setImage(UIImage(named: "btn_increase"), for: UIControlState())
        self.plusBtn.addTarget(self, action: #selector(PrdouctMenuTableViewCell.plusBtnClick(_:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(self.plusBtn)
        
        self.separateLine = UIView(frame:CGRect(x: 0,y: 85-0.5,width: screenWidth*0.7,height: 0.5))
        self.separateLine?.backgroundColor = UIColor.gray
        self.contentView.addSubview(self.separateLine!)
        
        
        self.minusBtn = UIButton(type: UIButtonType.custom)
        self.minusBtn.frame =  CGRect(x: (screenWidth*0.7) - 59,y: 36,width: 44,height: 44)
        self.minusBtn.setImage(UIImage(named: "btn_decrease"), for: UIControlState())
        self.minusBtn.addTarget(self, action: #selector(PrdouctMenuTableViewCell.minusBtnClick(_:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(self.minusBtn)
        
        self.buyCount = UILabel(frame: CGRect(x: (screenWidth*0.7) - 59,y: 36,width: 44,height: 44))
        self.buyCount.font = UIFont.systemFont(ofSize: 13)
        self.buyCount.textColor = UIColor.black
        self.buyCount.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(self.buyCount)
        
        self.contentView.bringSubview(toFront: self.plusBtn)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.productName.text = self.productNameStr
    }
    
    func plusBtnClick(_ btn:UIButton){
        let point:CGPoint = self.convert(btn.frame.origin, to: (UIApplication.shared.delegate?.window)!)
        let circleView:UIView = UIView(frame:CGRect(x: point.x,y: point.y,width: 20,height: 20))
        circleView.layer.cornerRadius = btn.frame.width / 2
        circleView.backgroundColor = UIColor.blue
        let window:UIWindow! = (UIApplication.shared.delegate?.window)!
        window.addSubview(circleView)
        let keyframeAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        let path:CGMutablePath = CGMutablePath()
            //动画的开始坐标
        path.move(to: CGPoint(x:circleView.layer.position.x, y:circleView.layer.position.y))
            //to:动画结束的坐标
            //control1:开始和结束中间的一个坐标
            //control2:开始和结束中间的第二个坐标
        path.addCurve(to: CGPoint(x:30, y:screenHeight-30), control1: CGPoint(x: circleView.layer.position.x-150, y: circleView.layer.position.y-30), control2: CGPoint(x: circleView.layer.position.x-200, y:  circleView.layer.position.y+40))
        keyframeAnimation.path = path
        keyframeAnimation.delegate = self
        keyframeAnimation.duration = 0.5
        circleView.layer.add(keyframeAnimation, forKey: "position");
            //动画完成后移除view
        circleView.perform(#selector(UIView.removeFromSuperview), with: nil, afterDelay: 0.45)
        
            ///实际项目中此处应加上对库存的判断
        if self.buyCount.text == nil
        {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.minusBtn.frame.origin.x = (screenWidth*0.7) - 157
                self.buyCount.frame.origin.x = (screenWidth*0.7) - 108
                self.minusBtn.alpha = 1.0
                self.buyCount.text = "1"
            }) 
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
    
    func minusBtnClick(_ btn:UIButton)
    {
            ///实际项目中此处应加上对库存的判断
        if Int(self.buyCount.text!) > 1
        {
            self.buyCount.text = String(Int(self.buyCount.text!)!-1)
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.minusBtn.frame.origin.x = (screenWidth*0.7) - 59
                self.buyCount.frame.origin.x = (screenWidth*0.7) - 59
                self.minusBtn.alpha = 0.0
                self.buyCount.text = nil
            }) 
        }
        if addProClosure != nil
        {
            addProClosure!(self,false)
        }
    }
}
