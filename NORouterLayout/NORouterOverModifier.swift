//
//  NORouterBottom.swift
//  NORouterLayout
//
//  Created by Deo on 2020/12/18.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NORouterOverModifier:ViewModifier{
    @EnvironmentObject private var routerViewModel:NORouterViewModel
    @State private var bottomSheetY:CGFloat = 0
    @State private var bottomSheetHeight:CGFloat = 0
    
    public init(){}
    
    public func body(content: Content) -> some View {
        return content
            .overlay(ZStack{
                if self.routerViewModel.coverView != nil{
                    self.routerViewModel.coverView.background(Color.white).clipShape(Rectangle()).transition(self.routerViewModel.transition)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity))
            .overlay(VStack{
                Spacer()
                if self.routerViewModel.bottomSheetView != nil {
                    self.routerViewModel.bottomSheetView
                        .background(GeometryReader { geometry in
                            Color.white.preference(key: SizePreferenceKey.self, value: geometry.size)
                        }.onPreferenceChange(SizePreferenceKey.self){ value in
                            self.bottomSheetHeight = value.height
                        })
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
            .background(Color.black.opacity(self.routerViewModel.bottomSheetView != nil ? 0.3 : 0).transition(.opacity)))
    }
    
    
    
}
