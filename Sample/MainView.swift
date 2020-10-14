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
    var body: some View{
        VStack{
            NONavigationBar{
                Button(action: {
                    self.routerViewModel.present(Router.Present.onCreateView(), "Present")
                }){Text("present PresentView")}
            }
            Spacer()
            Text("Hello, MainView!")
            Spacer()
            Button(action: {
                self.routerViewModel.sheet(Router.Sheet, "Sheet")
            }){Text("sheet SheetView")}
            Spacer()
            Button(action: {
                self.routerViewModel.present(Router.Present.onCreateView(), "Present")
            }){Text("present PresentView")}
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
