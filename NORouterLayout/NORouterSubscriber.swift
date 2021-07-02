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
    let storage:NOObservableObjectStorage
    
    init(contentView:AnyView, storage:NOObservableObjectStorage) {
        self.contentView = contentView
        self.storage = storage
    }
    
    func injectEnvironmentObject<T>(_ object: T) where T : ObservableObject {
        print(contentView)
        contentView = AnyView(contentView.environmentObject(object))
    }
    
    func injectEnvironmentObject<T:ObservableObject>(type:T.Type){
        print(contentView)
        if let object = storage.getEnvironmentObject(type: type) {
            contentView = AnyView(contentView.environmentObject(object))
        }
    }
}
