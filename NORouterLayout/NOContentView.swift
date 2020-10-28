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
        GeometryReader { geometry in
            ZStack{
                Color.clear.sheet(isPresented: self.$routerViewModel.isSheetView, onDismiss: {
                    self.routerViewModel.onDismiss()
                }) {
                    self.routerViewModel.sheetView
                }
                ZStack{
                    self.routerViewModel.contentView
                }
                .opacity(self.routerViewModel.opacity)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(edge)
            }
        }
    }
}
