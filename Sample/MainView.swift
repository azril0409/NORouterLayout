//
//  MainView.swift
//  Sample
//
//  Created by Deo on 2020/10/14.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import NORouterLayout

struct MainView:View {
    @EnvironmentObject private var routerViewModel:NORouterViewModel
    @State var showDetails = false
    var body: some View{
        VStack(spacing: 32.0){
            NONavigationBar{
                Button(action: {
                    self.routerViewModel.present(Router.Present.onCreateView(), "Present")
                }){Text("present PresentView")}
            }
            Spacer()
            Text("Hello, MainView!")
            Button(action: {
                self.routerViewModel.sheet(Router.Sheet, "Sheet")
            }){Text("sheet SheetView")}
            Button(action: {
                self.routerViewModel.present(Router.Present.onCreateView(), "Present")
            }){Text("present PresentView")}
            Button(action: {
                self.routerViewModel.bottomSheet(
                    VStack{
                        Button(action: { self.routerViewModel.dismissBottomSheet() }){Text("TEST")
                    }.frame(maxWidth: .infinity).frame(height: 300)}
                )
            }){Text("cover PresentView")}
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NOContentView().environmentObject(NORouterViewModel(Router.Main, "Main"))
    }
}
