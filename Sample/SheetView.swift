//
//  SheetView.swift
//  Sample
//
//  Created by Deo on 2020/10/14.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import NORouterLayout

struct SheetView:View {
    @EnvironmentObject private var routerViewModel:NORouterViewModel
    var body: some View{
        VStack{
            NONavigationBar()
            Spacer()
            Text("Hello, SheetView!")
            Spacer()
            Button(action: {
                self.routerViewModel.sheet(Router.Sheet, "Sheet")
            }){Text("sheet SheetView")}
            Spacer()
            Button(action: {
                self.routerViewModel.present(Router.Present, "Present")
            }){Text("present PresentView")}
            Spacer()
            Button(action: {
                self.routerViewModel.dismissSheet()
            }){Text("DISMISS SHEET")}
            Spacer()
        }
    }
}
