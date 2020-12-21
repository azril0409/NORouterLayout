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
    @EnvironmentObject private var test:TestObservableObject
    @State private var time = Date()
    @State var show = false
    
    var body: some View{
        VStack(spacing: 32.0){
            NONavigationBar(layer: {
                Button(action: {
                    self.routerViewModel.present(Router.Present, "Present", .move(edge: .trailing))
                }){Text("present PresentView")}
            }).background(Color.red)
            Spacer()
            Text("Hello, MainView!\nHello, \(String(describing: self.test))")
            Button(action: {
                self.routerViewModel.sheet(Router.Sheet, "Sheet")
            }){Text("sheet SheetView")}
            Button(action: {
                self.routerViewModel.present(Router.Present, "Present")
            }){Text("present PresentView")}
            Button(action: {
                self.routerViewModel.cover(Router.Present)
            }){Text("cover PresentView")}
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    print("show true")
                    self.show = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    print("show false")
                    self.show = false
                }
                self.routerViewModel.bottomSheet(ZStack{
                    Button(action: {
                        self.routerViewModel.dismissBottomSheet()
                    }, label: {
                        Text("dismiss BottomSheet")
                    })
                }.frame(maxWidth: .infinity).frame(height: 200))
            }){Text("bottomSheet D")}
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(NORouterOverModifier())
        .background(Color.yellow)
        .overlay(self.show ? Color.black : Color.clear)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NOContentView(Router.Main).injectEnvironmentObject(TestObservableObject())
    }
}
