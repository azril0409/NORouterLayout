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
    
    public init<Content:View>(_ contentView:Content,
                              name:String = "",
                              edge:Edge.Set = .all,
                              delegate:NORouterDelegate? = nil){
        self.edge = edge
        let estimateBarHeight = edge == .all || edge == .vertical || edge == .top
        self.routerViewModel = NORouterViewModel(contentView: contentView, name: name, delegate: delegate, estimateBarHeight: estimateBarHeight)
    }
    
    public init<Content:View>(_ contentView:Content,
                              name:String = "",
                              edge:Edge.Set = .all,
                              routerViewModel:NORouterViewModel){
        self.edge = edge
        let estimateBarHeight = edge == .all || edge == .vertical || edge == .top
        self.routerViewModel = NORouterViewModel(contentView: contentView, name: name, delegate: routerViewModel.delegate, storage: routerViewModel.storage, estimateBarHeight: estimateBarHeight)
    }
    
    public init<Router:RouterType>(_ routerType:Router,
                                   name:String = "",
                                   edge:Edge.Set = .all,
                                   delegate:NORouterDelegate? = nil){
        self.edge = edge
        let estimateBarHeight = edge == .all || edge == .vertical || edge == .top
        self.routerViewModel = NORouterViewModel(routerType: routerType, name: name, delegate: delegate, estimateBarHeight: estimateBarHeight)
    }
    
    public init<Router:RouterType>(_ routerType:Router,
                                   name:String="",
                                   edge:Edge.Set = .all,
                                   routerViewModel:NORouterViewModel){
        self.edge = edge
        let estimateBarHeight = edge == .all || edge == .vertical || edge == .top
        self.routerViewModel = NORouterViewModel(routerType: routerType, name: name, delegate: routerViewModel.delegate, storage: routerViewModel.storage, estimateBarHeight: estimateBarHeight)
    }
    
    public var body: some View {
        SceneView().edgesIgnoringSafeArea(edge).environmentObject(self.routerViewModel)
    }
    
    public func injectEnvironmentObject<T:ObservableObject>(_ object:T) -> NOContentView{
        routerViewModel.injectEnvironmentObject(object)
        return self
    }
    
    public func routerViewModel(_ sync:@escaping(NORouterViewModel)->Void) -> NOContentView{
        DispatchQueue.main.async {
            sync(self.routerViewModel)
        }
        return self
    }
}
