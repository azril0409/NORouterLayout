//
//  ContentLayout.swift
//  NORouterLayout
//
//  Created by Deo on 2020/9/9.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NOContentView: View {
    @EnvironmentObject private var routerViewModel:RouterViewModel
    public init(){}
    public var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.clear.sheet(isPresented: self.$routerViewModel.isSheetView) {
                    self.routerViewModel.sheetView
                }
                VStack{
                    ZStack{
                        self.routerViewModel.contentView
                    }.opacity(self.routerViewModel.opacity)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                ZStack{
                    self.routerViewModel.bottomView
                }
                .frame(height: geometry.size.height - 8)
                .frame(maxWidth: .infinity)
                .clipped()
                .background(Color.white.shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: -2))
                .offset(y: self.routerViewModel.bottomY)
                .animation(.linear)
            }
        }
    }
}

#if DEBUG
enum Router{
    case Main
    case Sheet
    case Present
    case Bottom
}

extension Router{
    var content: AnyView {
        switch self {
        case .Main: return AnyView(MainView())
        case .Sheet: return AnyView(SheetView())
        case .Present: return AnyView(PresentView())
        case .Bottom: return AnyView(BottomView())
        }
    }
}

struct MainView:View {
    @EnvironmentObject private var routerViewModel:RouterViewModel
    var body: some View{
        VStack{
            Spacer()
            Text("Hello, MainView!")
            Spacer()
            Button(action: {
                self.routerViewModel.sheet(Router.Sheet.content, "Sheet")
            }){Text("sheet SheetView")}
            Spacer()
            Button(action: {
                self.routerViewModel.bottom(Router.Bottom.content, "Bottom")
            }){Text("present BottomView")}
            Spacer()
            Button(action: {
                self.routerViewModel.present(Router.Present.content, "Present")
            }){Text("present PresentView")}
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SheetView:View {
    @EnvironmentObject private var routerViewModel:RouterViewModel
    var body: some View{
        VStack{
            Spacer()
            Text("Hello, SheetView!")
            Spacer()
            Button(action: {
                self.routerViewModel.sheet(Router.Sheet.content, "Sheet")
            }){Text("sheet SheetView")}
            Spacer()
            Button(action: {
                self.routerViewModel.present(Router.Present.content, "Present")
            }){Text("present PresentView")}
            Spacer()
            Button(action: {
                self.routerViewModel.dismiss()
            }){Text("DISMISS SHEET")}
            Spacer()
        }
    }
}

struct PresentView:View {
    @EnvironmentObject private var routerViewModel:RouterViewModel
    var body: some View{
        VStack{
            Spacer()
            Text("Hello, PresentView!")
            Spacer()
            Button(action: {
                self.routerViewModel.sheet(Router.Present.content, "Present")
            }){Text("sheet PresentView")}
            Spacer()
            Button(action: {
                self.routerViewModel.present(Router.Present.content, "Present")
            }){Text("present PresentView")}
            Spacer()
            Button(action: {
                self.routerViewModel.dismiss()
            }){Text("BACK \(self.routerViewModel.getPreviouName() ?? "")")}
            Spacer()
        }
    }
}

struct BottomView:View {
    @EnvironmentObject private var routerViewModel:RouterViewModel
    var body: some View{
        GeometryReader { geometry in
            VStack{
                Spacer()
                Text("Hello, BottomView!")
                Text("height:\(geometry.size.height)")
                Button(action: {
                    self.routerViewModel.bottom(Router.Bottom.content)
                }){Text("bottom Main")}
                Button(action: {
                    self.routerViewModel.dismiss()
                }){Text("DISMISS")}
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct NOContentView_Previews: PreviewProvider {
    static var previews: some View {
        let routerViewModel = RouterViewModel(Router.Main.content, "Main")
        return NOContentView().environmentObject(routerViewModel)
    }
}
#endif
