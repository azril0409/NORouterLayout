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
    @State private var bottomSheetY:CGFloat = 0
    @State private var bottomSheetHeight:CGFloat = 0
    
    public init(_ edge:Edge.Set = .all){
        self.edge = edge
    }
    
    public var body: some View {
        ZStack{
            Color.clear.sheet(isPresented: self.$routerViewModel.isSheetView, onDismiss: {
                self.routerViewModel.onDismiss()
            }) {
                self.routerViewModel.sheetView
            }
            Group{
                if !self.routerViewModel.isAnimationRunning {
                    self.routerViewModel.contentView.transition(self.routerViewModel.transition)
                }
            }
            Group{
                if self.routerViewModel.coverView != nil {
                    self.routerViewModel.coverView.clipShape(Rectangle()).background(Color.white).transition(self.routerViewModel.transition)
                }
            }
            Group{
                VStack{
                    Spacer()
                    if self.routerViewModel.bottomSheetView != nil {
                        self.routerViewModel.bottomSheetView
                            .background(GeometryReader { geometry in
                                Color.white.preference(key: SizePreferenceKey.self, value: geometry.size)
                            })
                            .onPreferenceChange(SizePreferenceKey.self){ value in
                                self.bottomSheetHeight = value.height
                            }
                            .offset(y:self.bottomSheetY)
                            .gesture(DragGesture()
                                        .onChanged{ value in
                                            if value.translation.height > 0 {
                                                self.bottomSheetY = value.translation.height
                                            }
                                        }.onEnded{ value in
                                            if self.bottomSheetHeight * 0.5 < abs(self.bottomSheetY){
                                                self.routerViewModel.dismissBottomSheet()
                                            }
                                            withAnimation(.spring()){
                                                self.bottomSheetY = 0
                                            }
                                        })
                            .transition(.move(edge: .bottom))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(self.routerViewModel.bottomSheetView != nil ? 0.3 : 0).transition(.opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(edge)
    }
}
