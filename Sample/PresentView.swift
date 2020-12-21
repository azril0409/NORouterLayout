//
//  PresentView.swift
//  Sample
//
//  Created by Deo on 2020/10/14.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import NORouterLayout

struct PresentView:View {
    @EnvironmentObject private var routerViewModel:NORouterViewModel
    @EnvironmentObject private var test:TestObservableObject
    var body: some View{
        VStack(spacing: 32.0){
            NONavigationBar()
            Spacer()
            Text("Hello, PresentView!\nHello, \(String(describing: self.test))")
            Button(action: {
                self.routerViewModel.sheet(Router.Present)
            }){Text("sheet PresentView")}
            Button(action: {
                self.routerViewModel.present(Router.Present, "Present")
            }){Text("present PresentView")}
            Button(action: {
                self.routerViewModel.dismiss()
            }){Text("BACK \(self.routerViewModel.getPreviouName() ?? "")")}
            Button(action: {
                self.routerViewModel.dismissCover()
            }){Text("close Cover")}
            Spacer()
        }
    }
}
