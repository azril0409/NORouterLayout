//
//  NORouterSubscriber.swift
//  NORouterLayout
//
//  Created by Deo on 2020/12/28.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public protocol NORouterSubscriber {
    func injectEnvironmentObject<T>(_ object:T) where T : ObservableObject
    func injectEnvironmentObject<T>(type:T.Type) where T : ObservableObject
}

class NORouterSubscriberImpl:NORouterSubscriber{
    var contentView:AnyView
    let storage:NOEnvironmentObjectStorage
    
    init(contentView:AnyView, storage:NOEnvironmentObjectStorage) {
        self.contentView = contentView
        self.storage = storage
    }
    
    func injectEnvironmentObject<T>(_ object: T) where T : ObservableObject {
        storage.injectEnvironmentObject(object: object)
        contentView = AnyView(contentView.environmentObject(object))
    }
    
    func injectEnvironmentObject<T:ObservableObject>(type:T.Type){
        if let object = storage.getEnvironmentObject(type: type) {
            contentView = AnyView(contentView.environmentObject(object))
        }
    }
}
