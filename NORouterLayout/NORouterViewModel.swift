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
    private var previouRouterViewModel:NORouterViewModel?
    private var viewHistory:[AnyView] = []
    private var nameList:[String] = []
    public let environmentObjectStorage:NOEnvironmentObjectStorage
    let onDismiss:()->Void
    @Published var contentName:String
    @Published var contentView:AnyView? = nil
    @Published var isAnimationRunning:Bool = false
    @Published var isSheetView:Bool = false
    @Published var sheetName:String? = .none
    @Published var sheetView:AnyView? = nil
    @Published var coverView:AnyView? = nil
    @Published var bottomSheetView:AnyView? = nil
    var contentRouter:RouterType? = nil
    var transition:AnyTransition = .opacity
    
    init<Content:View>(_ contentView:Content,
                              _ name:String="",
                              _ environmentObjectStorage:NOEnvironmentObjectStorage) {
        self.contentView = AnyView(contentView)
        self.contentName = name
        self.environmentObjectStorage = environmentObjectStorage
        self.previouRouterViewModel = .none
        self.onDismiss = {}
    }
    
    init<Router:RouterType>(_ routerType:Router,
                                   _ name:String="",
                                   _ environmentObjectStorage:NOEnvironmentObjectStorage) {
        self.contentRouter = routerType
        self.contentName = name
        self.environmentObjectStorage = environmentObjectStorage
        self.previouRouterViewModel = .none
        self.onDismiss = {}
    }
    
    init(_ contentView:AnyView,
                 _ name:String="",
                 _ environmentObjectStorage:NOEnvironmentObjectStorage,
                 _ previouRouterViewModel:NORouterViewModel,
                 _ onDismiss:@escaping ()->Void){
        self.contentView = contentView
        self.contentName = name
        self.environmentObjectStorage = environmentObjectStorage
        self.previouRouterViewModel = previouRouterViewModel
        self.onDismiss = onDismiss
    }
    
    func getContentViewByRouter() -> AnyView {
        self.contentView = self.contentRouter?.onCreateView(storage: self.environmentObjectStorage) ?? AnyView(EmptyView())
        return self.contentView!
    }

    public func present<Content:View>(_ presentView:Content, _ transition:AnyTransition = .opacity){
        self.present(presentView, "", transition)
    }
    
    public func present<Content:View>(_ presentView:Content, _ name:String = "", _ transition:AnyTransition = .opacity){
        self.present(AnyView(presentView), name, transition)
    }
    
    public func present(_ presentView:AnyView, _ transition:AnyTransition = .opacity){
        self.present(presentView, "", transition)
    }
    
    public func present(_ presentView:AnyView, _ name:String = "", _ transition:AnyTransition = .opacity){
        self.viewHistory.append(self.contentView!)
        self.nameList.append(self.contentName)
        self.isAnimationRunning = true
        self.transition = transition
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.isAnimationRunning = false
            self.contentView = presentView
            self.contentName = name
        }
    }
    
    public func present<Router:RouterType>(_ routerType:Router, _ transition:AnyTransition = .opacity){
        self.present(routerType, "", transition)
    }
    
    public func present<Router:RouterType>(_ routerType:Router, _ name:String = "", _ transition:AnyTransition = .opacity){
        self.viewHistory.append(self.contentView!)
        self.nameList.append(self.contentName)
        self.isAnimationRunning = true
        self.transition = transition
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.isAnimationRunning = false
            self.contentView = routerType.onCreateView(storage: self.environmentObjectStorage)
            self.contentName = name
        }
    }
    
    public func sheet<Content:View>(_ presentView:Content, _ transition:AnyTransition = .opacity, _ onDismiss:@escaping ()->Void = {}){
        self.sheet(presentView, "", transition, onDismiss)
    }
    
    public func sheet<Content:View>(_ presentView:Content, _ name:String = "", _ transition:AnyTransition = .opacity, _ onDismiss:@escaping ()->Void = {}){
        self.sheet(AnyView(presentView), name, transition, onDismiss)
    }
    
    public func sheet(_ sheetView:AnyView, _ transition:AnyTransition = .opacity, _ onDismiss:@escaping ()->Void = {}){
        self.sheet(sheetView, "", transition, onDismiss)
    }
    
    public func sheet(_ sheetView:AnyView, _ name:String = "", _ transition:AnyTransition = .opacity, _ onDismiss:@escaping ()->Void = {}){
        self.transition = transition
        self.sheetView = AnyView(ContentView().environmentObject(NORouterViewModel(sheetView, name, self.environmentObjectStorage, self, onDismiss)))
        self.isSheetView = true
    }
    
    public func sheet<Router:RouterType>(_ routerType:Router, _ transition:AnyTransition = .opacity,_ onDismiss:@escaping ()->Void = {}){
        self.sheet(routerType, "", transition, onDismiss)
    }
    
    public func sheet<Router:RouterType>(_ routerType:Router, _ name:String = "", _ transition:AnyTransition = .opacity,_ onDismiss:@escaping ()->Void = {}){
        self.transition = transition
        self.sheetView = AnyView(ContentView().environmentObject(NORouterViewModel(routerType.onCreateView(storage: self.environmentObjectStorage), name, self.environmentObjectStorage, self, onDismiss)))
        self.isSheetView = true
    }
    
    public func cover<Content:View>(_ coverView:Content, _ transition:AnyTransition = .move(edge: .bottom)){
        cover(AnyView(contentView), transition)
    }
    
    public func cover(_ coverView:AnyView, _ transition:AnyTransition = .move(edge: .bottom)){
        self.transition = transition
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.coverView = coverView
        }
    }
    
    public func cover<Router:RouterType>(_ routerType:Router, _ transition:AnyTransition = .move(edge: .bottom)){
        self.transition = transition
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.coverView = routerType.onCreateView(storage: self.environmentObjectStorage)
        }
    }
    
    public func bottomSheet<Content:View>(_ bottomSheetView:Content){
        self.bottomSheet(AnyView(bottomSheetView))
    }
    
    public func bottomSheet(_ bottomSheetView:AnyView){
        withAnimation(.spring()) {
            self.bottomSheetView = bottomSheetView
        }
    }
    
    public func bottomSheet<Router:RouterType>(_ routerType:Router){
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.bottomSheetView = routerType.onCreateView(storage: self.environmentObjectStorage)
        }
    }
    
    public func dismiss(){
        if viewHistory.isEmpty || self.nameList.isEmpty { return }
        self.isAnimationRunning = true
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
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
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.coverView = nil
        }
    }
    
    public func dismissBottomSheet(){
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.bottomSheetView = nil
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

