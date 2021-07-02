//
//  ContentView.swift
//  NORouterLayout
//
//  Created by Deo on 2020/12/7.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

struct SceneView: View {
    @EnvironmentObject private var routerViewModel:NORouterViewModel

    public var body: some View {
        ZStack{
            Spacer().sheet(isPresented: self.$routerViewModel.isSheetView, onDismiss: self.onDismiss, content: onSheetContent)
            if !self.routerViewModel.isAnimationRunning {
                self.routerViewModel.sceneView?.transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func onDismiss(){
        self.routerViewModel.onDismiss()
    }
    
    private func onSheetContent() -> some View{
        self.routerViewModel.sheetView
    }
}
