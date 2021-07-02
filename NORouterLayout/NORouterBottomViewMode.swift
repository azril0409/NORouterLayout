//
//  NORouterBottomViewMode.swift
//  NORouterLayout
//
//  Created by Deo on 2021/7/2.
//  Copyright © 2021 NeetOffice. All rights reserved.
//

import SwiftUI

public class NORouterBottomViewMode: ObservableObject {
    @Published var bottomSheetView:AnyView? = nil
    private var prbvm:NORouterBottomViewMode?
    private let delegate:NORouterDelegate
    private let storage:NOObservableObjectStorage
    
    init(delegate:NORouterDelegate, storage:NOObservableObjectStorage, prbvm:NORouterBottomViewMode?) {
        self.prbvm = prbvm
        self.delegate = delegate
        self.storage = storage
    }
    
    public func bottomSheet<Content:View>(_ bottomSheetView:Content){
        DispatchQueue.global(qos: .background).async {
            let sheetView = NORootViewCreator(bottomSheetView)
                    .setDelegate(self.delegate)
                    .setStorage(self.storage)
                    .setNORouterBottomViewMode(self)
                    .build()
            self.bottomSheetAnyView(AnyView(sheetView))
        }
    }
    
    public func bottomSheet<Router:RouterType>(_ routerType:Router){
        DispatchQueue.global(qos: .background).async {
            let sheetView = NORootViewCreator(routerType)
                    .setDelegate(self.delegate)
                    .setStorage(self.storage)
                    .setNORouterBottomViewMode(self)
                    .build()
            self.bottomSheetAnyView(AnyView(sheetView))
        }
    }
    
    private func bottomSheetAnyView(_ bottomSheetView:AnyView){
        DispatchQueue.main.async {
            withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
                self.bottomSheetView = bottomSheetView
            }
        }
    }
    
    public func dismissBottomSheet(){
        withAnimation(NORouterViewModel.DEFAULT_ANIMATION) {
            self.bottomSheetView = nil
        }
    }
}
