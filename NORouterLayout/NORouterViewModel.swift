//
//  RouterViewModel.swift
//  NORouterLayout
//
//  Created by Deo on 2020/9/9.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

public class NORouterViewModel:ObservableObject{
    static let DEFAULT_ANIMATION = Animation.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)
    var previouRouterViewModel:NORouterViewModel?
    var delegate:NORouterDelegate
    var storage:NOObservableObjectStorage
    /**
     
     */
    @Published var isAnimationRunning:Bool = false
    @Published var sceneView:AnyView? = nil
    @Published var contentName:String
    var sceneEdge:Edge.Set = .init()
    private var viewHistory:[AnyView] = []
    private var nameList:[String] = []
    /**
     
     */
    @Published var isSheetView:Bool = false
    @Published var sheetName:String? = nil
    @Published var sheetView:AnyView? = nil
    let onDismiss:()->Void
    
    public init() {
        previouRouterViewModel = nil
        delegate = NORouterDelegateImpl()
        storage = NOObservableObjectStorage()
        self.contentName = ""
        onDismiss = {}
    }
}

//MARK: Get conent view name
extension NORouterViewModel{
    public func getConentName()->String{
        self.contentName
    }
    
    public func getPreviouName() -> String? {
        self.nameList.last ?? (self.previouRouterViewModel == nil ? nil : self.previouRouterViewModel?.contentName)
    }
}


//MARK: Dismiss operation
extension NORouterViewModel{
    
    public func canDismiss() -> Bool{
        !self.viewHistory.isEmpty
    }
    
    public func dismiss(){
        if viewHistory.isEmpty || self.nameList.isEmpty { return }
        self.isAnimationRunning = true
        self.sceneView = nil
        withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
            self.sceneView = self.viewHistory.removeLast()
            self.contentName = self.nameList.removeLast()
            self.isAnimationRunning = false
        }
    }
    
    public func dismiss(to name:String){
        self.isAnimationRunning = true
        withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
            self.isAnimationRunning = false
            while self.contentName != name {
                if viewHistory.isEmpty || self.nameList.isEmpty { return }
                self.sceneView = self.viewHistory.removeLast()
                self.contentName = self.nameList.removeLast()
            }
        }
    }
    
}

//MARK: Present operation
extension NORouterViewModel{
    public func present<Router:RouterType>(_ routerType:Router, _ name:String = ""){
        self.present(routerType.onCreateView(storage: self.storage), name)
    }
    
    public func present<Content:View>(_ content:Content, _ name:String = ""){
        self.present(AnyView(content), name)
    }
    
    public func present(_ view:AnyView, _ name:String = ""){
        guard let sceneView = self.sceneView else { return }
        self.viewHistory.append(sceneView)
        self.nameList.append(self.contentName)
        self.isAnimationRunning = true
        self.sceneView = nil
        let impl = NORouterSubscriberImpl(contentView: view, storage: self.storage)
        delegate.onInjectObject(subscriber: impl)
        DispatchQueue.main.async {
            withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
                self.sceneView = impl.contentView
                self.contentName = name
                self.isAnimationRunning = false
            }
        }
    }
}

//MARK: Replace operation
extension NORouterViewModel{

    public func replace<Router:RouterType>(_ routerType:Router, _ name:String = ""){
        self.replace(routerType.onCreateView(storage: self.storage), name)
    }
    
    
    public func replace<Content:View>(_ content:Content, _ name:String = ""){
        self.replace(AnyView(content), name)
    }
    
    public func replace(_ view:AnyView, _ name:String = ""){
        self.isAnimationRunning = true
        self.sceneView = nil
        let impl = NORouterSubscriberImpl(contentView: view, storage: self.storage)
        delegate.onInjectObject(subscriber: impl)
        DispatchQueue.main.async {
            withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
                self.sceneView = impl.contentView
                self.contentName = name
                self.isAnimationRunning = false
            }
        }
    }
}

//MARK:Sheet operation
extension NORouterViewModel{
    public func sheet<Router:RouterType>(_ routerType:Router, _ name:String = "", _ onDismiss:@escaping ()->Void = {}){
        self.sheet(routerType.onCreateView(storage: self.storage), name, onDismiss)
    }
    
    public func sheet<Content:View>(_ presentView:Content, _ name:String = "", _ onDismiss:@escaping ()->Void = {}){
        self.sheet(AnyView(presentView), name, onDismiss)
    }
    
    public func sheet(_ sheetView:AnyView, _ name:String = "", _ onDismiss:@escaping ()->Void = {}){
        DispatchQueue.global(qos: .background).async {
            let sheetView = NORootViewCreator.init(sheetView)
                .setName(name)
                .setDelegate(self.delegate)
                .setStorage(self.storage)
                .setPreviouRouterViewModel(self)
                .build()
            DispatchQueue.main.async {
                self.sheetView = AnyView(sheetView)
                self.isSheetView = true
            }
        }
    }
    
    public func canDismissSheet() -> Bool{
        return self.isSheetView || self.previouRouterViewModel?.isSheetView == true
    }
    
    public func dismissSheet(){
        if self.isSheetView {
            self.isSheetView = false
            self.sheetView = .none
        }else if let viewModel = self.previouRouterViewModel {
            viewModel.isSheetView = false
            viewModel.sheetView = .none
        }
    }
}
