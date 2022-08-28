//
//  SwiftDoCatch.swift
//  MyLearn
//
//  Created by jianhua zhang on 2020/12/22.
//  Copyright © 2020 jianhua zhang. All rights reserved.
//

import Foundation
import UIKit

class ThrowsError {
    func showThrows() -> Void {
        //售卖
        let favoriteSnaks = [
            "Alice": "Chips",
            "Bob": "Licorice",
            "Eve": "Pretzels"
        ]
        //一个买东西的方法
        func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
            let snackName = favoriteSnaks[person] ?? "Candy Bar"
            try vendingMachine.vend(itemNamed: snackName)
        }
        //捕获错误示例
        //一个自动售货机
        let vendingMachine = VendingMachine()
        //收到的投币数
        vendingMachine.coinsDeposited = 8
        do {
            //对买东西这一操作捕获异常
            try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
            print("Success! Yum.")
        } catch VendingMachineError.invalidSelection {
            //没有这种商品
            print("Invalid Selection.")
        } catch VendingMachineError.outOfStock {
            //投币不足
            print("Out of stock.")
        }catch VendingMachineError.insufficientFunds(let coinsNeeded) {
            //投币不足
            print("Insufficient founds. Please insert an additional \(coinsNeeded) coins")
        } catch {
            print("Unexpected error: \(error)")
        }
        //let？ 使用示例
        let x = try? someThrowingFunction()
        let y: Int?
        do {
            y = try someThrowingFunction()
        } catch {
            y = nil
        }
    }
}

//错误表示
// Swift中，如果我们要定义一个表示错误的类型非常简单，只要遵循Error协议就可以了，我们通常用枚举或结构体表示错误类型，枚举类型更为合适，因为它能更加直观的表达当前错误类型的每种错误细节

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

//如何抛出错误
//
func canThrowErrors() throws -> String {
    return "error code " + VendingMachineError.invalidSelection.localizedDescription
}

func cannotThrowErrors() -> String {
    return "error"
}

struct Item {
    var price: Int
    var count: Int
}

//自动贩卖机
class VendingMachine {
    //商品列表
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),//糖条
        "Chips": Item(price: 10, count: 4),//土豆条
        "Pretzels": Item(price: 7, count: 11)//饼干
    ]
    //投币的属性
    var coinsDeposited = 0
    //售卖方法
    // 函数接收一个商品名参数
    func vend(itemNamed name: String) throws {
        //判断商品列表里有没有这种商品名称，没有抛出异常
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        //库存不够 报异常
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        //投币数大于单价OK 否则（投币不够）抛出异常，还需要多少个硬币
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        print("Dispensing \(name)")
    }
}

// 利用do-cache 捕获错误
// Swift 中我们使用do-catch 块对错误进行捕获，当我们在调用一个throws声明的函数或方法时，我们必须把调用语句放在do语句快中，同时 do语句块后面紧跟着使用catch 语句块
/*
do {
    try expression
    statements
}catch  pattern1 {
    statements
}catch pattern2 where condition {
    statements
}catch {
    statements
}
*/

//try?
// try? 会将错误转换为可选值，当调用try? + 函数或方法语句的时候，如果函数或方法抛出错误，程序不会发生崩溃，而是返回一个nil, 如果没有抛出错误，则返回可选值
func  someThrowingFunction() throws -> Int {
    //
    return 1
}

//try!
// 如果你确信一个函数或方法不会抛出错误，可以使用try! 来中断错误的传播。但是如果错误真的发生了，你会得到一个运行时错误
//let photo = try! loadImage(atPath: "./Resources/image.jpg")

// 指定退出的清理操作
//defer 关键字： defer block 里的代码会在函数 return 之前执行，无论函数时从哪个分支return的，还是有throw, 还是自然而然走到最后一行
/*
func processFile(fileName: String) throws {
    if exists(fileName) {
        let fine = open(fileName)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            //work with the file
        }
        // close(file) is called here. at the end of the scope.
    }
}
*/
