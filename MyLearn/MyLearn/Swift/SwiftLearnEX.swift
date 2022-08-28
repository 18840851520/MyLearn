//
//  SwiftLearnEX.swift
//  MyLearn
//
//  Created by jianhua zhang on 2020/12/14.
//  Copyright © 2020 jianhua zhang. All rights reserved.
//

import Foundation
import UIKit

/*枚举 默认是int*/
enum MyLearnType{
    case start
    case end
}
/*嵌套枚举*/
enum MyLearnPlay{
    enum load {
        case start
        case finish
    }
    enum play {
        case start
        case playing
        case played
        case end
    }
}
/*关联值*/
enum MyStatus {
    case Play(name:String,time:String)
    case Learn(name:String,time:String)
}
/*String枚举*/
enum MyLearnTypeString : String{
    case start = "startString"
    case end = "endString"
}
//枚举方法和属性
enum Device {
    case iPad,iPhone
    //属性
    var system:String{
        switch self {
        case .iPad:
            return "iPadOS"
        default:
            return "iOS"
        }
    }
    //方法
    func deviceName() -> String {
        switch self {
        case .iPad:
            return "iPad"
        default:
            return "other"
        }
    }
    //静态函数
    static func valueFor(modelName:String) -> Device?{
        if modelName == "iPad" {
            return .iPad
        }
        return nil
    }
}
//枚举还支持协议式
protocol CustomDescription {
    var description: String { get }
}
enum Trade :CustomStringConvertible{
    case Buy(stock:String,amount:Int)
    case Sell(stock:String,amount:Int)
    var description: String {
        switch self {
        case .Buy(_, _):
            return "Buy"
            
        case .Sell(_, _):
            return "Sell"
        }
    }
}
//枚举 扩展类似枚举添加方法
extension Device: CustomStringConvertible{
    func sayHello() -> String {
        return "Hello Device:CustomStringConvertible"
    }
    var description: String {
        switch self {
        case .iPhone:
            return "iPhone"
        default:
            return "other"
        }
    }
}
//泛型
enum goodsPrice<P> {
    case price(P)
    func getPrice() -> P {
        switch self {
        case .price(let value1):
            return value1
        }
    }
}
/*扩展*/
/*
 添加计算型属性和计算静态属性
 定义实例方法和类型方法
 提供新的构造器
 定义下标
 定义和使用新的嵌套类型
 使一个已有类型符合某个接口
 */
extension String{
    func sayHello() -> String! {
        return "扩展 Hello,swift World"
    }
}

/**协议*/
/*
 protocol 用于定义多个类型应该遵守的规范
 */
protocol MyLearnProtocol {
    var myLearnProject:String{get}
}
/*
 struct 声明定义一个结构体
 */
struct Person : MyLearnProtocol {
    var myLearnProject : String
    let multiplier : Int
    /*
     subscript 下标索引修饰,使用下标访问内部的值
     例子
     let person = Person(multiplier: 3)
     println("six times three is \(person[7])")
     */
    subscript(index:Int) -> Int{
        return multiplier * index
    }
}
class XiaoMing: MyLearnProtocol {
    var projectName : String
    init(projectName:String) {
        self.projectName = projectName
    }
    var myLearnProject: String{
        return "协议 现在学习的"+self.projectName
    }
    
}
/**
 subscript 重写Array的下标引用
 var some = ["1","2"]
 print(some[2]);数组越界不会闪退
 */
extension Array {
    func testCode() -> Void {
        print("Array extension");
    }
    subscript(input: [Int]) -> ArraySlice<Any> {
        get {
            var array = ArraySlice<Any>()
            for i in input {
                assert(i < self.count, "index out of range")
                array.append(self[i])
            }
            return array
        }
//        set {
//            // i表示数组input自己的索引，index表示数组self的索引
//            for (i, index) in Array.enumerate(input) {
//                assert(index < self.count, "index out of range")
//                self[index] = newValue[i]
//            }
//        }
    }
}
/**
 typealias 为此类型声明一个别名.和 typedef类似
    let point: CGPoint = CGPoint(x: 0,y: 0)
    //等价于
    let point: JHPoint = CGPoint(x: 0,y: 0)
 */
typealias JHPoint = CGPoint
/*
 typealias 闭包定义
    var callBack: successCallback?
    self.callBack!(code: "0",message: "ok")
*/
typealias successCallback = (_ code: String, _ message: String) -> Void

/*
 protocol、Generic 泛型 where的用法
 protocol   UIButton().getInfo()
 Generic    genericFunc(num: Bird())
*/
protocol SomeProtocol {
    func say()
}
extension SomeProtocol where Self: UIView {
    // 只给遵守SomeProtocol协议的UIView添加了拓展方法
    func getInfo() -> String {
        return "属于UIView类型"
    }
}
extension UIButton: SomeProtocol {
    func say() {
        
    }
    /**
     convenience:便利，使用convenience修饰的构造函数叫做便利构造函数
     便利构造函数的特点：
     1、便利构造函数通常都是写在extension里面
     2、便利函数init前面需要加载convenience
     3、在便利构造函数中需要明确的调用self.init()
     */
    convenience init(imageName: String,bgImageName: String){
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        sizeToFit()
    }
}
func genericFunc<T>(num: T) where T: SomeProtocol {
    print(num)
}

struct Bird: SomeProtocol {
    func say() {
        print("Hello World")
    }
}
