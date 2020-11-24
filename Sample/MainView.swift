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
    @State private var time = Date()
    
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
                    ZStack{
                        DatePicker("", selection: self.$time, displayedComponents: .date)
                            .aspectRatio(CGSize(width: 4, height: 4), contentMode: .fit)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                )
            }){Text("bottomSheet D")}
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
