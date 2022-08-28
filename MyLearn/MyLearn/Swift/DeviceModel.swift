//
//  DeviceModel.swift
//  MyLearn
//
//  Created by jianhua zhang on 2020/12/9.
//  Copyright © 2020 jianhua zhang. All rights reserved.
//

import UIKit

private var key_new : Void?
/*
 UIDevice 扩展获取设备名称
 */
extension UIDevice{
    /**
     当前设备名称
     */
    var deviceModelName : String! {
        get{
            var value_old = objc_getAssociatedObject(self, &key_new) as? String
            if (value_old == nil) {
                guard let url = Bundle.main.url(forResource: "DeviceModel", withExtension: "plist") else {
                    return ""
                }
                guard let data = try? Data(contentsOf: url) else {
                    return ""
                }
                let deviveData : NSDictionary = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSDictionary
                let identifier = self.deviceIdentifier()
                value_old = (deviveData.value(forKey: identifier) as? String)
                objc_setAssociatedObject(self, &key_new, value_old, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return value_old
        }
    }
    func deviceIdentifier() -> String{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { (identifier, element) in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier as! String
    }
}

