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
            Spacer().sheet(isPresented: self.$routerViewModel.isSheetView, onDismiss: {
                self.routerViewModel.onDismiss()
            }) {
                self.routerViewModel.sheetView
            }
            if !self.routerViewModel.isAnimationRunning {
                if let sceneView = self.routerViewModel.sceneView {
                    sceneView
                }else if let sceneView = self.routerViewModel.getContentView(){
                    sceneView
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
