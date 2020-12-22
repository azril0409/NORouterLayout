//
//  ContentLayout.swift
//  NORouterLayout
//
//  Created by Deo on 2020/9/9.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import Combine

public struct NOContentView: View {
    private let edge:Edge.Set
    private let routerViewModel:NORouterViewModel
    private let storage:NOEnvironmentObjectStorage
    
    public init<Content:View>(_ contentView:Content,
                              name:String = "",
                              edge:Edge.Set = .all){
        self.edge = edge
        self.storage = NOEnvironmentObjectStorage()
        self.routerViewModel = NORouterViewModel(contentView, name, storage)
    }
    
    public init<Content:View>(_ contentView:Content,
                              name:String = "",
                              edge:Edge.Set = .all,
                              storage:NOEnvironmentObjectStorage){
        self.edge = edge
        self.storage = storage
        self.routerViewModel = NORouterViewModel(contentView, name, storage)
    }
    
    public init<Router:RouterType>(_ routerType:Router,
                                   name:String="",
                                   edge:Edge.Set = .all){
        self.edge = edge
        self.storage = NOEnvironmentObjectStorage()
        self.routerViewModel = NORouterViewModel(routerType, name, storage)
    }
    
    public init<Router:RouterType>(_ routerType:Router,
                                   name:String="",
                                   edge:Edge.Set = .all,
                                   storage:NOEnvironmentObjectStorage){
        self.edge = edge
        self.storage = storage
        self.routerViewModel = NORouterViewModel(routerType, name, storage)
    }
    
    public var body: some View {
        ContentView(self.edge).environmentObject(self.routerViewModel)
    }
    
    public func injectEnvironmentObject<T:ObservableObject>(_ object:T) -> NOContentView{
        storage.injectEnvironmentObject(object: object)
        if routerViewModel.contentView != nil {
            routerViewModel.contentView = AnyView(routerViewModel.contentView.environmentObject(object))
        }
        return self
    }
    
    public func routerViewModel(_ sync:@escaping(NORouterViewModel)->Void) -> NOContentView{
        DispatchQueue.main.async {
            sync(self.routerViewModel)
        }
        return self
    }
}
