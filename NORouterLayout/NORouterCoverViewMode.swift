//
//  NORouterCoverViewMode.swift
//  NORouterLayout
//
//  Created by Deo on 2021/7/2.
//  Copyright © 2021 NeetOffice. All rights reserved.
//

import SwiftUI

public class NORouterCoverViewMode:ObservableObject{
    @Published var coverView:AnyView? = nil
    private var previouNORouterCoverViewMode:NORouterCoverViewMode?
    private let delegate:NORouterDelegate
    private let storage:NOObservableObjectStorage
    
    init(delegate:NORouterDelegate, storage:NOObservableObjectStorage, prcvm:NORouterCoverViewMode?) {
        self.delegate = delegate
        self.previouNORouterCoverViewMode = prcvm
        self.storage = storage
    }
    
    public func cover<Content:View>(_ coverView:Content){
        print("cover Content \(coverView)")
        DispatchQueue.global(qos: .background).async {
            self.coverAnyView(AnyView(NORootViewCreator(coverView)
                                .setDelegate(self.delegate)
                                .setStorage(self.storage)
                                .setNORouterCoverViewMode(self)
                                .build()))
        }
    }
    
    public func cover<Router:RouterType>(_ routerType:Router){
        print("cover Router \(routerType)")
        DispatchQueue.global(qos: .background).async {
            self.coverAnyView(AnyView(NORootViewCreator(routerType)
                                .setDelegate(self.delegate)
                                .setStorage(self.storage)
                                .setNORouterCoverViewMode(self)
                                .build()))
        }
    }
    
    private func coverAnyView(_ coverView:AnyView){
        print("coverAnyView \(coverView)")
        DispatchQueue.main.async {
            withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
                self.coverView = coverView
            }
        }
    }
    
    public func canDismiss() -> Bool{
        if self.coverView != nil{
            return true
        }else if let prcvm = self.previouNORouterCoverViewMode{
            return prcvm.coverView != nil
        }else{
            return false
        }
    }
    
    public func dismiss(){
        withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
            if self.coverView != nil{
                self.coverView = nil
            }else if let prcvm = self.previouNORouterCoverViewMode{
                prcvm.coverView  = nil
            }
        }
    }
}
