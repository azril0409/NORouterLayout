//
//  Router.swift
//  Sample
//
//  Created by Deo on 2020/10/14.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import NORouterLayout

enum Router{
    case Main
    case Sheet
    case Present
}

extension Router:RouterType{
    func onCreateView(storage: NOEnvironmentObjectStorage) -> AnyView {
        let object = storage.getEnvironmentObject(type: TestObservableObject.self)
        switch self {
        case .Main: return AnyView(MainView().environmentObject(object!))
        case .Sheet: return AnyView(SheetView())
        case .Present: return AnyView(PresentView().environmentObject(object!))
        }
    }
}
