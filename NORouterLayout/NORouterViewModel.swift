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
    @Published var contentName:String
    @Published var contentView:AnyView
    @Published var opacity:Double = 1;
    @Published var isSheetView:Bool = false
    @Published var sheetName:String? = .none
    @Published var sheetView:AnyView? = .none
    @Published var bottomName:String? = .none
    @Published var bottomView:AnyView? = .none
    @Published var bottomY:CGFloat = UIScreen.main.bounds.height
    
    public init(_ contentView:AnyView, _ name:String="") {
        self.contentView = contentView
        self.contentName = name
        self.previouRouterViewModel = .none
    }
    
    private init(_ contentView:AnyView, _ name:String="", _ previouRouterViewModel:NORouterViewModel){
        self.contentView = contentView
        self.contentName = name
        self.previouRouterViewModel = previouRouterViewModel
    }
    
    public func present(_ presentView:AnyView, _ name:String = ""){
        self.viewHistory.append(self.contentView)
        self.nameList.append(self.contentName)
        self.opacity = 0
        withAnimation(.linear) {
            self.opacity = 1
            self.contentView = presentView
            self.contentName = name
        }
    }
    
    public func sheet(_ sheetView:AnyView, _ name:String = ""){
        self.sheetView = AnyView(NOContentView().environmentObject(NORouterViewModel(sheetView, name, self)))
        self.isSheetView = true
    }
    
    public func bottomSheet(_ bottomView:AnyView, _ name:String = ""){
        self.bottomView =  AnyView(NOContentView().environmentObject(NORouterViewModel(bottomView, name,self)))
        self.bottomY = 8
    }
    
    public func dismiss(){
        if viewHistory.isEmpty || self.nameList.isEmpty { return }
        self.opacity = 0
        withAnimation(.linear) {
            self.opacity = 1
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
    
    public func dismissBottomSheet(){
        if let viewModel = self.previouRouterViewModel {
            viewModel.bottomY = UIScreen.main.bounds.height
            viewModel.bottomView = .none
        }
    }
    
    public func getConentName()->String{
        self.contentName
    }
    
    public func getPreviouName() -> String? {
        self.nameList.last
    }
}
