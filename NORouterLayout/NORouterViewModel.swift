//
//  RouterViewModel.swift
//  NORouterLayout
//
//  Created by Deo on 2020/9/9.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import UIKit

public class NORouterViewModel:ObservableObject{
    private var previouRouterViewModel:NORouterViewModel?
    private var viewHistory:[AnyView] = []
    private var nameList:[String] = []
    let onDismiss:()->Void
    @Published var contentName:String
    @Published var contentView:AnyView
    @Published var isAnimationRunning:Bool = false
    @Published var isSheetView:Bool = false
    @Published var sheetName:String? = .none
    @Published var sheetView:AnyView? = .none
    @Published var coverView:AnyView? = .none
    var transition:AnyTransition = .opacity
    
    public init<Content:View>(_ contentView:Content, _ name:String="", _ transition:AnyTransition = .opacity) {
        self.contentView = AnyView(contentView)
        self.contentName = name
        self.previouRouterViewModel = .none
        self.onDismiss = {}
    }
    
    public init<Router:RouterType>(_ routerType:Router, _ name:String="", _ transition:AnyTransition = .opacity) {
        self.contentView = routerType.onCreateView()
        self.contentName = name
        self.previouRouterViewModel = .none
        self.onDismiss = {}
    }
    
    private init(_ contentView:AnyView, _ name:String="", _ previouRouterViewModel:NORouterViewModel, _ onDismiss:@escaping ()->Void){
        self.contentView = contentView
        self.contentName = name
        self.previouRouterViewModel = previouRouterViewModel
        self.onDismiss = onDismiss
    }
    
    public func present<Content:View>(_ presentView:Content, _ name:String = "", _ transition:AnyTransition = .opacity){
        self.present(AnyView(presentView), name, transition)
    }
    
    public func present(_ presentView:AnyView, _ name:String = "", _ transition:AnyTransition = .opacity){
        self.viewHistory.append(self.contentView)
        self.nameList.append(self.contentName)
        self.isAnimationRunning = true
        self.transition = transition
        withAnimation(.linear) {
            self.isAnimationRunning = false
            self.contentView = presentView
            self.contentName = name
        }
    }
    
    public func present<Router:RouterType>(_ routerType:Router, _ name:String = "", _ transition:AnyTransition = .opacity){
        self.viewHistory.append(self.contentView)
        self.nameList.append(self.contentName)
        self.isAnimationRunning = true
        self.transition = transition
        withAnimation(.linear) {
            self.isAnimationRunning = false
            self.contentView = routerType.onCreateView()
            self.contentName = name
        }
    }
    
    
    public func sheet<Content:View>(_ presentView:Content, _ name:String = "", _ transition:AnyTransition = .opacity, _ onDismiss:@escaping ()->Void = {}){
        self.sheet(AnyView(presentView), name, transition, onDismiss)
    }
    
    public func sheet(_ sheetView:AnyView, _ name:String = "", _ transition:AnyTransition = .opacity, _ onDismiss:@escaping ()->Void = {}){
        self.transition = transition
        self.sheetView = AnyView(NOContentView().environmentObject(NORouterViewModel(sheetView, name, self, onDismiss)))
        self.isSheetView = true
    }
    
    public func sheet<Router:RouterType>(_ routerType:Router, _ name:String = "", _ transition:AnyTransition = .opacity,_ onDismiss:@escaping ()->Void = {}){
        self.transition = transition
        self.sheetView = AnyView(NOContentView().environmentObject(NORouterViewModel(routerType.onCreateView(), name, self, onDismiss)))
        self.isSheetView = true
    }
    
    public func cover<Content:View>(_ coverView:Content, _ transition:AnyTransition = .move(edge: .bottom)){
        cover(AnyView(contentView), transition)
    }
    
    public func cover(_ coverView:AnyView, _ transition:AnyTransition = .move(edge: .bottom)){
        self.transition = transition
        withAnimation(.linear){
            self.coverView = coverView
        }
    }
    
    public func cover<Router:RouterType>(_ routerType:Router, _ transition:AnyTransition = .move(edge: .bottom)){
        self.transition = transition
        withAnimation(.linear){
            self.coverView = routerType.onCreateView()
        }
    }
    
    public func dismiss(){
        if viewHistory.isEmpty || self.nameList.isEmpty { return }
        self.isAnimationRunning = true
        withAnimation(.linear) {
            self.isAnimationRunning = false
            self.contentView = self.viewHistory.removeLast()
            self.contentName = self.nameList.removeLast()
        }
    }
    
    public func dismissSheet(){
        if let viewModel = self.previouRouterViewModel {
            viewModel.isSheetView = false
            viewModel.sheetView = .none
        }
    }
    
    public func dismissCover(){
        withAnimation{
            self.coverView = nil
        }
    }
    
    public func canDismiss() -> Bool{
        !self.nameList.isEmpty
    }
    
    public func canDismissSheet() -> Bool{
        self.previouRouterViewModel != nil
    }
    
    public func canDismissCover() -> Bool{
        self.coverView != nil
    }
    
    public func getConentName()->String{
        self.contentName
    }
    
    public func getPreviouName() -> String? {
        self.nameList.last ?? (self.previouRouterViewModel == nil ? nil : self.previouRouterViewModel?.contentName)
    }
    
}
