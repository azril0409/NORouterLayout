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
    public var delegate:NORouterDelegate?
    var storage:NOEnvironmentObjectStorage
    var estimateBarHeight:Bool
    private var contentView:AnyView? = nil
    private var contentRouter:RouterType? = nil
    
    /**
     
     */
    @Published var isAnimationRunning:Bool = false
    @Published var sceneView:AnyView? = nil
    @Published var contentName:String
    private var viewHistory:[AnyView] = []
    private var nameList:[String] = []
    /**
     
     */
    @Published var isSheetView:Bool = false
    @Published var sheetName:String? = nil
    @Published var sheetView:AnyView? = nil
    let onDismiss:()->Void
    
    /**
     
     */
    @Published var coverView:AnyView? = nil
    
    /**
     
     */
    @Published var bottomSheetView:AnyView? = nil
    
    public init<Content:View>(contentView:Content,
                              name:String = ""){
        self.contentView = AnyView(contentView)
        previouRouterViewModel = nil
        delegate = nil
        storage = NOEnvironmentObjectStorage()
        self.contentName = name
        self.estimateBarHeight = false
        onDismiss = {}
    }
    
    public init<Router:RouterType>(routerType:Router,
                              name:String = ""){
        self.contentRouter = routerType
        previouRouterViewModel = nil
        delegate = nil
        storage = NOEnvironmentObjectStorage()
        self.contentName = name
        self.estimateBarHeight = false
        onDismiss = {}
    }
    
    init() {
        previouRouterViewModel = nil
        delegate = nil
        storage = NOEnvironmentObjectStorage()
        self.contentName = ""
        self.estimateBarHeight = false
        onDismiss = {}
    }
    
    func onInit<Content:View>(contentView:Content,
                       name:String = "",
                       delegate:NORouterDelegate?,
                       storage:NOEnvironmentObjectStorage = NOEnvironmentObjectStorage(),
                       estimateBarHeight:Bool) {
        self.contentView = AnyView(contentView)
        self.contentName = name
        self.delegate = delegate
        self.previouRouterViewModel = nil
        self.storage = storage
        self.estimateBarHeight = estimateBarHeight
    }
    
    func onInit<Router:RouterType>(routerType:Router,
                            name:String = "",
                            delegate:NORouterDelegate?,
                            storage:NOEnvironmentObjectStorage = NOEnvironmentObjectStorage(),
                            estimateBarHeight:Bool) {
        self.contentRouter = routerType
        self.contentName = name
        self.delegate = delegate
        self.previouRouterViewModel = nil
        self.storage = storage
        self.estimateBarHeight = estimateBarHeight
    }
    
    func onInit(routerViewModel:NORouterViewModel) {
        self.contentView = routerViewModel.contentView
        self.contentRouter = routerViewModel.contentRouter
        self.contentName = routerViewModel.contentName
        self.delegate = routerViewModel.delegate
        self.previouRouterViewModel = routerViewModel.previouRouterViewModel
        self.storage = routerViewModel.storage
        self.estimateBarHeight = routerViewModel.estimateBarHeight
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
}

/**
 
 */

extension NORouterViewModel{
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
    
    public func getConentName()->String{
        self.contentName
    }
    
    public func getPreviouName() -> String? {
        self.nameList.last ?? (self.previouRouterViewModel == nil ? nil : self.previouRouterViewModel?.contentName)
    }
}

/**
 
 */
//MARK:Content
extension NORouterViewModel{
    public func present<Router:RouterType>(_ routerType:Router){
        self.present(routerType, "")
    }
    
    public func present<Router:RouterType>(_ routerType:Router, _ name:String = ""){
        self.present(routerType.onCreateView(storage: self.storage), name)
    }
    
    public func present<Content:View>(_ presentView:Content){
        self.present(presentView, "")
    }
    
    public func present<Content:View>(_ presentView:Content, _ name:String = ""){
        self.present(AnyView(presentView), name)
    }
    
    public func present(_ presentView:AnyView){
        self.present(presentView, "")
    }
    
    public func present(_ presentView:AnyView, _ name:String = ""){
        if self.sceneView == nil {
            self.sceneView = self.getContentView()
        }
        self.viewHistory.append(self.sceneView!)
        self.nameList.append(self.contentName)
        self.sceneView = nil
        self.isAnimationRunning = true
        let impl = NORouterSubscriberImpl(contentView: presentView, storage: self.storage)
        self.delegate?.routerOnCreateView(impl)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.isAnimationRunning = false
            self.sceneView = impl.contentView
            self.contentName = name
        }
    }
    
    public func canDismiss() -> Bool{
        !self.viewHistory.isEmpty
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
    
    public func dismiss(to name:String){
        self.isAnimationRunning = true
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.isAnimationRunning = false
            while self.contentName != name {
                if viewHistory.isEmpty || self.nameList.isEmpty { return }
                self.sceneView = self.viewHistory.removeLast()
                self.contentName = self.nameList.removeLast()
            }
        }
    }
    
}

/**
 
 */
//MARK:Sheet
extension NORouterViewModel{
    
    public func sheet<Router:RouterType>(_ routerType:Router, _ transition:AnyTransition = .opacity,_ onDismiss:@escaping ()->Void = {}){
        self.sheet(routerType, "", transition, onDismiss)
    }
    
    public func sheet<Router:RouterType>(_ routerType:Router, _ name:String = "", _ transition:AnyTransition = .opacity,_ onDismiss:@escaping ()->Void = {}){
        self.sheet(routerType.onCreateView(storage: self.storage))
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
        DispatchQueue.global(qos: .background).async {
            let impl = NORouterSubscriberImpl(contentView: sheetView, storage: self.storage)
            self.delegate?.routerOnCreateView(impl)
            DispatchQueue.main.async {
                self.sheetView = AnyView(SceneView().environmentObject(NORouterViewModel(contentView: impl.contentView, name: name, delegate: self.delegate, previouRouterViewModel: self, storage: self.storage, estimateBarHeight: false, onDismiss: onDismiss)).transition(transition))
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

/**
 
 */
//MARK:Cover
extension NORouterViewModel{
    
    public func cover<Content:View>(_ coverView:Content, _ transition:AnyTransition = .move(edge: .bottom)){
        DispatchQueue.global(qos: .background).async {
            self.cover(AnyView(coverView), transition)
        }
    }
    
    public func cover<Router:RouterType>(_ routerType:Router, _ transition:AnyTransition = .move(edge: .bottom)){
        DispatchQueue.global(qos: .background).async {
            self.cover(routerType.onCreateView(storage: self.storage), transition)
        }
    }
    
    public func cover(_ coverView:AnyView, _ transition:AnyTransition = .move(edge: .bottom)){
        DispatchQueue.main.async {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
                self.coverView = coverView
            }
        }
    }
    
    public func canDismissCover() -> Bool{
        if self.coverView != nil{
            return true
        }else  if let previouRouterViewModel = self.previouRouterViewModel {
            return previouRouterViewModel.canDismissCover()
        }else{
            return false
        }
    }
    
    public func dismissCover(){
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            if self.coverView != nil{
                self.coverView = nil
            }else if let previouRouterViewModel = self.previouRouterViewModel {
                previouRouterViewModel.coverView = nil
            }
        }
    }
}

/**
 
 */
//MARK:BottomSheet
extension NORouterViewModel{
    
    public func bottomSheet<Content:View>(_ bottomSheetView:Content){
        DispatchQueue.global(qos: .background).async {
            self.bottomSheet(AnyView(bottomSheetView))
        }
    }
    
    public func bottomSheet<Router:RouterType>(_ routerType:Router){
        DispatchQueue.global(qos: .background).async {
            self.bottomSheet(routerType.onCreateView(storage: self.storage))
        }
    }
    
    public func bottomSheet(_ bottomSheetView:AnyView){
        DispatchQueue.main.async {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
                self.bottomSheetView = bottomSheetView
            }
        }
    }
    
    public func dismissBottomSheet(){
        withAnimation(.spring(response: 0.35, dampingFraction: 0.72, blendDuration: 0)) {
            self.bottomSheetView = nil
        }
    }
}
