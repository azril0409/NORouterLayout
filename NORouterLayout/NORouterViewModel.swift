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
    public let delegate:NORouterDelegate?
    let onDismiss:()->Void
    let storage:NOEnvironmentObjectStorage
    let estimateBarHeight:Bool
    @Published var sceneView:AnyView? = nil
    @Published var contentName:String
    @Published var isAnimationRunning:Bool = false
    @Published var isSheetView:Bool = false
    @Published var sheetName:String? = .none
    @Published var sheetView:AnyView? = nil
    @Published var coverView:AnyView? = nil
    @Published var bottomSheetView:AnyView? = nil
    var transition:AnyTransition = .opacity
    private var contentView:AnyView? = nil
    private var contentRouter:RouterType? = nil
    
    init<Content:View>(contentView:Content,
                       name:String = "",
                       delegate:NORouterDelegate?,
                       storage:NOEnvironmentObjectStorage = NOEnvironmentObjectStorage(),
                       estimateBarHeight:Bool) {
        self.contentView = AnyView(contentView)
        self.contentName = name
        self.delegate = delegate
        self.previouRouterViewModel = .none
        self.onDismiss = {}
        self.storage = storage
        self.estimateBarHeight = estimateBarHeight
    }
    
    init<Router:RouterType>(routerType:Router,
                            name:String = "",
                            delegate:NORouterDelegate?,
                            storage:NOEnvironmentObjectStorage = NOEnvironmentObjectStorage(),
                            estimateBarHeight:Bool) {
        self.contentRouter = routerType
        self.contentName = name
        self.delegate = delegate
        self.previouRouterViewModel = .none
        self.onDismiss = {}
        self.storage = storage
        self.estimateBarHeight = estimateBarHeight
    }
    
    init(contentView:AnyView,
         name:String = "",
         delegate:NORouterDelegate?,
         previouRouterViewModel:NORouterViewModel,
         storage:NOEnvironmentObjectStorage = NOEnvironmentObjectStorage(),
         estimateBarHeight:Bool,
         onDismiss:@escaping ()->Void){
        self.contentView = contentView
        self.contentName = name
        self.delegate = delegate
        self.previouRouterViewModel = previouRouterViewModel
        self.onDismiss = onDismiss
        self.storage = storage
        self.estimateBarHeight = estimateBarHeight
    }
    
    func getContentView() -> AnyView {
        let view:AnyView
        if let contentRouter = self.contentRouter {
            view = contentRouter.onCreateView(storage: self.storage)
        } else if let contentView = self.contentView {
            view = contentView
        } else {
            view = AnyView(EmptyView())
        }
        let impl = NORouterSubscriberImpl(contentView: view, storage: self.storage)
        self.delegate?.routerOnCreateView(impl)
        self.sceneView = impl.contentView
        self.contentView = nil
        self.contentRouter = nil
        return self.sceneView!
    }
    
    func injectEnvironmentObject<T:ObservableObject>(_ object:T){
        self.storage.injectEnvironmentObject(object: object)
        if let contentView = self.contentView, delegate == nil {
            self.contentView = AnyView(contentView.environmentObject(object))
        }
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
        self.viewHistory.append(self.sceneView!)
        self.nameList.append(self.contentName)
        self.isAnimationRunning = true
        self.transition = transition
        let impl = NORouterSubscriberImpl(contentView: presentView, storage: self.storage)
        self.delegate?.routerOnCreateView(impl)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.isAnimationRunning = false
            self.sceneView = impl.contentView
            self.contentName = name
        }
    }
    
    public func present<Router:RouterType>(_ routerType:Router, _ transition:AnyTransition = .opacity){
        self.present(routerType, "", transition)
    }
    
    public func present<Router:RouterType>(_ routerType:Router, _ name:String = "", _ transition:AnyTransition = .opacity){
        self.viewHistory.append(self.sceneView!)
        self.nameList.append(self.contentName)
        self.isAnimationRunning = true
        self.transition = transition
        let impl = NORouterSubscriberImpl(contentView: routerType.onCreateView(storage: self.storage), storage: self.storage)
        self.delegate?.routerOnCreateView(impl)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.isAnimationRunning = false
            self.sceneView = impl.contentView
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
        let impl = NORouterSubscriberImpl(contentView: sheetView, storage: self.storage)
        self.delegate?.routerOnCreateView(impl)
        self.sheetView = AnyView(SceneView().environmentObject(NORouterViewModel(contentView: impl.contentView, name: name, delegate: self.delegate, previouRouterViewModel: self, storage: self.storage, estimateBarHeight: false, onDismiss: onDismiss)))
        self.isSheetView = true
    }
    
    public func sheet<Router:RouterType>(_ routerType:Router, _ transition:AnyTransition = .opacity,_ onDismiss:@escaping ()->Void = {}){
        self.sheet(routerType, "", transition, onDismiss)
    }
    
    public func sheet<Router:RouterType>(_ routerType:Router, _ name:String = "", _ transition:AnyTransition = .opacity,_ onDismiss:@escaping ()->Void = {}){
        self.transition = transition
        let impl = NORouterSubscriberImpl(contentView: routerType.onCreateView(storage: self.storage), storage: self.storage)
        self.delegate?.routerOnCreateView(impl)
        self.sheetView = AnyView(SceneView().environmentObject(NORouterViewModel.init(contentView: impl.contentView, name: name, delegate: self.delegate, previouRouterViewModel: self, storage: self.storage, estimateBarHeight: false, onDismiss: onDismiss)))
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
            self.coverView = routerType.onCreateView(storage: self.storage)
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
            self.bottomSheetView = routerType.onCreateView(storage: self.storage)
        }
    }
    
    public func dismiss(){
        if viewHistory.isEmpty || self.nameList.isEmpty { return }
        self.isAnimationRunning = true
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.isAnimationRunning = false
            self.sceneView = self.viewHistory.removeLast()
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
            self.previouRouterViewModel?.coverView = nil
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
        self.previouRouterViewModel?.coverView != nil
    }
    
    public func getConentName()->String{
        self.contentName
    }
    
    public func getPreviouName() -> String? {
        self.nameList.last ?? (self.previouRouterViewModel == nil ? nil : self.previouRouterViewModel?.contentName)
    }
    
}

