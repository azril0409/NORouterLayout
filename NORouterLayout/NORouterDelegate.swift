//
//  NORouterDelegate.swift
//  NORouterLayout
//
//  Created by Deo on 2020/12/28.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import Foundation

public protocol NORouterDelegate{
    func onCreateObservableObject(storage:NOObservableObjectStorage)
    func onInjectObject(subscriber:NORouterSubscriber)
}

class NORouterDelegateImpl:NORouterDelegate{
    func onCreateObservableObject(storage: NOObservableObjectStorage) {
        
    }
    
    func onInjectObject(subscriber: NORouterSubscriber) {
        
    }
}
