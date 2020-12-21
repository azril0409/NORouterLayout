//
//  NORouterDelegate.swift
//  NORouterLayout
//
//  Created by Deo on 2020/12/18.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public class NOEnvironmentObjectStorage{
    var objects:[String:AnyObject] = [:]
    init(){}
    
    func injectEnvironmentObject<T:ObservableObject>(object:T){
        let type = String(describing:object).components(separatedBy: ".").last!
        objects[type] = object
    }
    
    public func getEnvironmentObject<T>(type:T.Type) -> T?{
        let type = String(describing:type)
        let object = objects[type]
        return object as? T
    }
}
