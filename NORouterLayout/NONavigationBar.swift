//
//  NONavigationBar.swift
//  NORouterLayout
//
//  Created by Deo on 2020/10/14.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NONavigationBar: View {
    @EnvironmentObject private var routerViewModel:NORouterViewModel
    private let labelLayer:AnyView
    private let menuLayer:AnyView
    
    public init(){
        self.labelLayer = AnyView(EmptyView())
        self.menuLayer = AnyView(EmptyView())
    }
    
    public init<BarButtonLayer:View>(@ViewBuilder layer:@escaping ()->BarButtonLayer) {
        self.labelLayer = AnyView(EmptyView())
        self.menuLayer = AnyView(layer())
    }
    
    public init<LabelLayer:View>(@ViewBuilder label:@escaping ()->LabelLayer) {
        self.labelLayer = AnyView(label())
        self.menuLayer = AnyView(EmptyView())
    }
    
    public init<LabelLayer:View, BarButtonLayer:View>(@ViewBuilder label:@escaping ()->LabelLayer, @ViewBuilder layer:@escaping ()->BarButtonLayer) {
        self.labelLayer = AnyView(label())
        self.menuLayer = AnyView(layer())
    }
    
    public var body: some View {
        HStack{
            if self.routerViewModel.getPreviouName() != nil {
                Button(action: {
                    if self.routerViewModel.canDismiss(){
                        self.routerViewModel.dismiss()
                    }else{
                        self.routerViewModel.dismissSheet()
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 8){
                        Image(systemName: "arrow.left")
                        Text(routerViewModel.getPreviouName() ?? "").font(.system(size: 24)).minimumScaleFactor(0.5)
                    }
                })
            }
            self.labelLayer
            Spacer()
            self.menuLayer
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        .padding(8)
        .padding(.top, self.routerViewModel.canDismissSheet() ? 0 : self.safeAreaTopPadding())
    }
    
    private func safeAreaTopPadding() -> CGFloat{
        UIApplication.shared.windows.first?.safeAreaInsets.top ?? 16
    }
    
}

