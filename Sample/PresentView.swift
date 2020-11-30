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
    var body: some View{
        VStack(spacing: 32.0){
            NONavigationBar().background(Color.red).accentColor(.white)
            Spacer()
            Text("Hello, PresentView!")
            Button(action: {
                self.routerViewModel.sheet(Router.Present)
            }){Text("sheet PresentView")}
            Button(action: {
                self.routerViewModel.present(Router.Present.onCreateView(), "Present")
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
