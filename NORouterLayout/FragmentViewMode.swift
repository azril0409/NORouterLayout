//
//  FrameView.swift
//  NORouterLayout
//
//  Created by Deo on 2021/7/2.
//  Copyright © 2021 NeetOffice. All rights reserved.
//

import SwiftUI

public class FragmentViewMode: ObservableObject{
    @Published var isAnimationRunning:Bool = false
    @Published var fragmentView:AnyView? = nil
    @Published var fragmentName:String? = nil
    private var viewHistory:[AnyView] = []
    private var nameList:[String] = []
    
    public init(){
        
    }
    
    public init<Content:View>(content:Content, name:String? = nil){
        self.fragmentView = AnyView(content)
        self.fragmentName = name
    }
}

//MARK: back operation
extension FragmentViewMode{
    
    public func canBack() -> Bool{
        !self.viewHistory.isEmpty
    }
    
    public func back(){
        if viewHistory.isEmpty || self.nameList.isEmpty { return }
        self.isAnimationRunning = true
        self.fragmentView = nil
        withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
            self.fragmentView = self.viewHistory.removeLast()
            self.fragmentName = self.nameList.removeLast()
            self.isAnimationRunning = false
        }
    }
    
    public func back(to name:String){
        self.isAnimationRunning = true
        withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
            self.isAnimationRunning = false
            while self.fragmentName != name {
                if viewHistory.isEmpty || self.nameList.isEmpty { return }
                self.fragmentView = self.viewHistory.removeLast()
                self.fragmentName = self.nameList.removeLast()
            }
        }
    }
}

//MARK: Add operation
extension FragmentViewMode{
    public func add<Router:RouterType>(_ routerType:Router, _ name:String = "", rvm:NORouterViewModel){
        self.add(routerType.onCreateView(storage: rvm.storage), name)
    }
    
    public func add<Content:View>(_ presentView:Content, _ name:String = ""){
        self.add(AnyView(presentView), name)
    }
    
    public func add(_ view:AnyView, _ name:String = ""){
        guard let fragmentView = self.fragmentView else { return }
        self.viewHistory.append(fragmentView)
        self.nameList.append(self.fragmentName ?? "")
        self.isAnimationRunning = true
        self.fragmentView = nil
        DispatchQueue.main.async {
            withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
                self.fragmentView = view
                self.fragmentName = name
                self.isAnimationRunning = false
            }
        }
    }
}

//MARK: Replace operation
extension FragmentViewMode{
    public func replace<Router:RouterType>(_ routerType:Router, _ name:String = "", rvm:NORouterViewModel){
        self.replace(routerType.onCreateView(storage: rvm.storage), name)
    }
    
    
    public func replace<Content:View>(_ content:Content, _ name:String = ""){
        self.replace(AnyView(content), name)
    }
    
    public func replace(_ view:AnyView, _ name:String = ""){
        self.isAnimationRunning = true
        self.fragmentView = nil
        DispatchQueue.main.async {
            withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
                self.fragmentView = view
                self.fragmentName = name
                self.isAnimationRunning = false
            }
        }
    }
}
