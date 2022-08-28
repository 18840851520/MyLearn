//
//  SwiftLearn.swift
//  MyLearn
//
//  Created by jianhua zhang on 2020/12/7.
//  Copyright © 2020 jianhua zhang. All rights reserved.
//

import Foundation
//引入框架，头文件
import UIKit
/*
 基本数据类型
 */
var myString = "Hello,Swift!"

/*
 class 声明类
 */
class MyLearnSwift: NSObject {
    /*
     var 声明变量
     */
    var myString = "Hello,Swift!"
    var classEnum = MyLearnType.start
    /*
     init       初始化函数 构造函数
     override   关键字  重写某个方法, 或者某个属性
     */
    override init() {
        super.init()
        var uSArr = Array<Int>.init()
        let num = (pow(Decimal.init(10),9) as NSNumber).uint32Value
        for _ in 1...100000 {
            let num1 = arc4random_uniform(num)
            uSArr.append(Int(num1))
        }
        print(myString)
        /*
         let 声明静态变量，不可再赋值
         基本数据类型,分号的使用
         */
        let myString1 = "Hello,Swift!";print(myString1)
        let `swiftView` = "UIView"
        print("分号的使用"+swiftView)
        //枚举
        self.showCase()
        //方法调用
        let code = learnProject(projectName: "learning")
        //where的用法
        showWhereUsage()
        //闭包表达式
        showClosureExpression()
        
        showExemple()
        showTestCode()
    }
    func showExemple() -> Void {
        //单一隐式返回
        let count = [1,2,5,8,10]
        let deCount = count.sorted { (n1:Int, n2:Int) -> Bool in
            return n1 < n2
        }
        /**
         等同于 进行从小到大的排序
         let numbersSorted = numbers.sorted{
             return $0 < $1 / $0 < $1
         最精简的代码
         let numbersSorted = numbers.sorted{ $0 < $1 }
         */
        print("数组-\(deCount)")
        
        let btn = UIButton.init()
        //is 类似OC isKindClass
        if btn is UIView {
            print("")
        }
        /**
         as 有保证的转换，从派生类转换为基类的向上转型
         as? 选择性转换 转换失败返回nil
         as! 强制性转换 转换失败报错
         */
        // as将整型1 转成float,从派生类转换为基类的向上转型
        let num = 1 as CGFloat
        /**
         #column:   列号
         #file:     路径
         #function: 函数
         #line:     行号
         type(of: num) 动态类型
         */
        print("COLUMN = (#column) \n FILE = (#file) \n FUNCTION = (#function) \n LINE = (#line) type \(type(of: num))")
        //这样，如果它是空，就返回`""`（空字符串）
        var foo: String?
        let bar = foo ?? ""
        print("空字符串\(foo)\(bar)")
        
        //自定义前缀
        let sum = 1+++3
        let string_null = foo~~
        print("自定义前缀 1+++3 = \(sum) 空字符自动转 \(string_null)")
        
        /**
         weak 弱引用
         */
        let closure = { [weak self] in
            self?.learnProject(projectName: "弱引用") //Remember, all weak variables are Optionals!
            
        }
        let count_weak = closure()
        print("弱引用\(count_weak)")
        
        
    }
    /*
     func 声明方法
    */
    func learnProject(projectName:String?) -> Int {
        print("我的项目\(projectName ?? "空的")")
        print("项目\(projectName)")
        return 0
    }
    /*
     属于析构函数，类似delloc，对象结束其生命周期时，系统自动执行析构函数
     */
    deinit{
        //移除通知
        NotificationCenter.default.removeObserver(self)
        print("deinit对象销毁，KVO移除，移除通知，NSTimer销毁")
    }
    /*枚举使用用例*/
    func showCase() -> Void {
        print(UIDevice.current.deviceModelName)
        print("枚举数据\(classEnum)")
        classEnum = MyLearnType.end
        print("枚举数据\(classEnum)")
        //枚举具体场景比较
        if classEnum == .end {
            print("枚举具体场景比较 YES");
        }
        //遍历枚举
        classEnum = MyLearnType.end
        switch classEnum {
        case .start:
            print("枚举遍历 start")
        case .end:
            print("枚举遍历 end")
            /**
             fallthrough 继续执行下面的case
             */
            fallthrough
        default:()
            print("枚举遍历 其他")
        }
        //枚举
        let typeString = MyLearnTypeString(rawValue: "startString")
        print(typeString!)
        print(MyLearnPlay.play.start)
        print(MyLearnTypeString.start)
        print("枚举" + MyLearnTypeString.start.rawValue)
        //关联值枚举
        let mystatus = MyStatus.Play(name: "卡牌", time: "一天")
        switch mystatus {
        case .Play(let name,let time):
                print("关联值枚举：我玩了\(time)的\(name)")
            default:
                ()
        }
        //枚举方法变量使用
        //静态声明的函数可以直接调用类似 类方法
        print("枚举变量和方法" + Device.iPhone.deviceName() + " " + (Device.valueFor(modelName: "iPad")?.deviceName())!)
        //协议式枚举
        print("协议式枚举" + Trade.Buy(stock: "01111", amount: 100).description)
        //泛型
        print(goodsPrice<Int>.price(100).getPrice())
    }
    /**
     final 不可重写，可以将类或者类中的部分实现保护起来 集成的子类无法重写
     */
    final func eat(){
        print("final 吃饭")
    }
    /**
     where 的用法
     */
    func showWhereUsage() -> Void {
        let names = ["王小二", "张三", "李四", "王五"]
        for name in names {
            switch name {
            //switch中筛选
            case let x where x.hasPrefix("王"):
                print("姓王的有：\(x)")
            case let x where x.hasPrefix("李"):
                print("姓李的有：\(x)")
                fallthrough// 执行到此并不跳出循环,而是继续执行
            case let x where x.hasPrefix("三"):
                print("姓李的叫：\(name)")
            default:
                print("你好，\(name)")
            }
        }
        //
        let array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        for value in array where value % 2 == 0 {
            print("where的用法\(value)")
        }
        do {
            let path:String? = Bundle.main.path(forResource: "text", ofType: "txt")
//            let str = try NSString(contentsOfFile:path!, encoding:String.Encoding.utf8.rawValue)
//            print(str)
        }catch let err as NSError {
            print(err.description)
        }
    }
    /**
     闭包 的用法
     */
    func showClosureExpression() -> Void {
        //闭包写法一
        let sum = {
            (v1:Int,v2:Int) -> Int in
                return v1+v2
        }
        print("闭包写法一\(sum(1,2))")
        //闭包写法二
        let total = {
            (v1:Int,v2:Int) -> Int in
                return v1+v2
        }(2,5)
        print("闭包写法一\(total)")
        /**
         函数的最后一个参数，且这个参数是一个闭包表达式
         */
        func exec(v1:Int,v2:Int,total1:(Int,Int) -> Int) ->Int{
            print("尾随闭包1- \(total1(v1,v2))")
            return v1+v2
        }
        let ex = exec(v1: 10, v2: 20) { (v1, v2) -> Int in
            return v1*v2
        }
        print("尾随闭包2- \(ex)")
    }
}

func showTestCode() -> Void {
    
}
/**
 运算符
 左（前缀）：prefix
 右（后缀）：postfix
 中（中缀）：infix
 */
postfix operator ~~
postfix func ~~(a:String?)      ->String    { return a == nil ? "" : a! }
postfix func ~~(a:Int?)         ->Int       { return a == nil ? 0 : a! }

//定义优先级
/// 定义优先级组
precedencegroup MyPrecedence {
    // higherThan: AdditionPrecedence   // 优先级,比加法运算高
    lowerThan: AdditionPrecedence       // 优先级, 比加法运算低
    associativity: none                 // 结合方向:left, right or none
    assignment: false                   // true=赋值运算符,false=非赋值运算符
}
///
infix operator +++: MyPrecedence        // 继承 MyPrecedence 优先级组
// infix operator +++: AdditionPrecedence // 也可以直接继承加法优先级组(AdditionPrecedence)或其他优先级组
func +++(left: Int, right: Int) -> Int {
    return left+right*2
}

