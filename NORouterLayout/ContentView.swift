//
//  ContentView.swift
//  NORouterLayout
//
//  Created by Deo on 2020/12/7.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var routerViewModel:NORouterViewModel
    private let edge:Edge.Set
    
    public init(_ edge:Edge.Set = .all){
        self.edge = edge
    }
    
    public var body: some View {
        ZStack{
            Spacer().sheet(isPresented: self.$routerViewModel.isSheetView, onDismiss: {
                self.routerViewModel.onDismiss()
            }) {
                self.routerViewModel.sheetView
            }
            if !self.routerViewModel.isAnimationRunning {
                if self.routerViewModel.contentView != nil {
                    self.routerViewModel.contentView.transition(self.routerViewModel.transition)
                }else {
                    self.routerViewModel.getContentViewByRouter().transition(self.routerViewModel.transition)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(edge)
    }
}
