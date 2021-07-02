//
//  NORootViewCreator.swift
//  NORouterLayout
//
//  Created by Deo on 2021/7/2.
//  Copyright © 2021 NeetOffice. All rights reserved.
//

import SwiftUI


public class NORootViewCreator {
    private let contentView:AnyView?
    private let routerType:RouterType?
    private var name = ""
    private var viewModel = NORouterViewModel()
    private var edge = Edge.Set.all
    private var delegate:NORouterDelegate = NORouterDelegateImpl()
    private var previouRouterViewModel:NORouterViewModel? = nil
    private var bcvm:NORouterBottomViewMode? = nil
    private var rcvm:NORouterCoverViewMode? = nil
    private var storage:NOObservableObjectStorage? = nil
    
    public init<Content:View>(_ contentView:Content){
        self.contentView = AnyView(contentView)
        self.routerType = nil
    }
    
    public init<Type:RouterType>(_ routerType:Type){
        self.contentView = nil
        self.routerType = routerType
    }
    
    public func setDelegate(_ delegate:NORouterDelegate) -> NORootViewCreator{
        self.delegate = delegate
        return self
    }
    
    public func setEdge(_ edge:Edge.Set) -> NORootViewCreator{
        self.edge = edge
        return self
    }
    
    public func setName(_ name:String) -> NORootViewCreator{
        self.name = name
        return self
    }
    
    public func setRouterViewModel(_ viewModel:NORouterViewModel) -> NORootViewCreator{
        self.viewModel = viewModel
        return self
    }
    
    func setStorage(_ storage:NOObservableObjectStorage) -> NORootViewCreator {
        self.storage = storage
        return self
    }
    
    func setPreviouRouterViewModel(_ viewModel:NORouterViewModel) -> NORootViewCreator{
        self.previouRouterViewModel = viewModel
        return self
    }
    
    func setNORouterBottomViewMode(_ viewMode:NORouterBottomViewMode) -> NORootViewCreator {
        self.bcvm = viewMode
        return self
    }
    
    func setNORouterCoverViewMode(_ viewMode:NORouterCoverViewMode) -> NORootViewCreator {
        self.rcvm = viewMode
        return self
    }
    
    public func build() -> some View{
        self.viewModel.previouRouterViewModel = previouRouterViewModel
        self.viewModel.delegate = delegate
        self.viewModel.sceneEdge = edge
        let storage:NOObservableObjectStorage
        if self.storage == nil {
            delegate.onCreateObservableObject(storage: self.viewModel.storage)
            storage = self.viewModel.storage
        }else{
            storage = self.storage!
        }
        let view = SceneView()
            .edgesIgnoringSafeArea(edge)
            .environmentObject(self.viewModel)
            .environmentObject(NORouterCoverViewMode(delegate: self.delegate, storage: storage, prcvm: self.rcvm))
            .environmentObject(NORouterBottomViewMode(delegate: self.delegate, storage: storage, prbvm: self.bcvm))
        if let contentView = contentView {
            self.viewModel.sceneView = AnyView(contentView)
        }else if let routerType = routerType {
            self.viewModel.sceneView = routerType.onCreateView(storage: storage)
        }else {
            self.viewModel.sceneView = AnyView(EmptyView())
        }
        let impl = NORouterSubscriberImpl(contentView: AnyView(view), storage: storage)
        delegate.onInjectObject(subscriber: impl)
        self.viewModel.contentName = name
        return impl.contentView
    }
}
