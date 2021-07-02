//
//  NORouterBottom.swift
//  NORouterLayout
//
//  Created by Deo on 2020/12/18.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NORouterOverModifier:ViewModifier{
    @EnvironmentObject private var bvm:NORouterBottomViewMode
    @EnvironmentObject private var coverViewMode:NORouterCoverViewMode
    @State private var bottomSheetY:CGFloat = 0
    @State private var bottomSheetHeight:CGFloat = 0
    
    public init(){}
    
    public func body(content: Content) -> some View {
        return content
            .overlay(self.cover())
            .overlay(VStack{
                Spacer()
                if self.bvm.bottomSheetView != nil {
                    self.bvm.bottomSheetView
                        .background(self.bottomSheetBackground())
                        .offset(y:self.bottomSheetY)
                        .gesture(DragGesture()
                                    .onChanged{ value in
                                        if value.translation.height > 0 {
                                            self.bottomSheetY = value.translation.height
                                        }
                                    }.onEnded{ value in
                                        if self.bottomSheetHeight * 0.5 < abs(self.bottomSheetY){
                                            self.bvm.dismissBottomSheet()
                                        }
                                        withAnimation(.spring()){
                                            self.bottomSheetY = 0
                                        }
                                    })
                        .transition(.move(edge: .bottom))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(self.bvm.bottomSheetView != nil ? 0.3 : 0).transition(.opacity)))
    }
    
    private func cover() -> some View{
        Group{
            if self.coverViewMode.coverView != nil{
                self.coverViewMode.coverView!.background(Color.white).clipShape(Rectangle()).transition(.move(edge: .bottom))
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func bottomSheetBackground() -> some View{
        GeometryReader { geometry in
            Color.white.preference(key: SizePreferenceKey.self, value: geometry.size)
        }.onPreferenceChange(SizePreferenceKey.self){ value in
            self.bottomSheetHeight = value.height
        }
    }
    
}
