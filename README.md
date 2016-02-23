# MenuChoice
高仿外卖app的点餐页(swift)</br>
本demo中没有加上数据库操作，所以在cell重用的时候会有bug,实际项目应按需求对数据库进行操作</br></br>

1.将GroupTableView.swift,PrdouctMenuTableViewCell.swift导入到项目中即可</br>

2.调用
```
init(frame:CGRect,MenuTypeArr:[String],proNameArr:[AnyObject])
```
初始化

添加按钮的动画效果，修改第三，四个参数可改变抛物线弧度</br>
```
CGPathAddQuadCurveToPoint(path, nil, 100, circleView.layer.position.y+50, 30, screenHeight-30)
```

demo中的类别cell没有自定义，如果需求可自定义cell

如果本demo对您有帮助，欢迎star</br>
如果本demo对您有帮助，欢迎star</br>
如果本demo对您有帮助，欢迎star</br></br>

如果您发现了bug,希望你能Issues我</br>
如果您发现了bug,希望你能Issues我</br>
如果您发现了bug,希望你能Issues我</br>

![](https://github.com/judy9452/MenuChoice/blob/master/MenuChoice.gif)
