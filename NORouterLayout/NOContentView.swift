//
//  ContentLayout.swift
//  NORouterLayout
//
//  Created by Deo on 2020/9/9.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NOContentView: View {
    @EnvironmentObject private var routerViewModel:NORouterViewModel
    private let edge:Edge.Set
    
    public init(_ edge:Edge.Set = .all){
        self.edge = edge
    }
    
    public var body: some View {
        ZStack{
            Group{
                if !self.routerViewModel.isAnimationRunning {
                    self.routerViewModel.contentView.transition(self.routerViewModel.transition)
                }
            }
            Group{
                if self.routerViewModel.coverView != nil {
                    self.routerViewModel.coverView.clipShape(Rectangle()).transition(self.routerViewModel.transition)
                }
            }.sheet(isPresented: self.$routerViewModel.isSheetView, onDismiss: {
                self.routerViewModel.onDismiss()
            }) {
                self.routerViewModel.sheetView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(edge)
    }
}
