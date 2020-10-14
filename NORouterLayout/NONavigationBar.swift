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
    private let layer:AnyView
    
    public init(){
        layer = AnyView(EmptyView())
    }
    
    public init<BarButtonLayer:View>(@ViewBuilder layer:@escaping ()->BarButtonLayer) {
        self.layer = AnyView(layer())
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
                        Text(routerViewModel.getPreviouName() ?? "")
                    }
                })
            } 
            Spacer()
            self.layer
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .padding(8)
        .padding(.top, UIDevice().bangsHeight())
    }
}
