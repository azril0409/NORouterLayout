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
    func onCreateView() -> AnyView {
        switch self {
        case .Main: return AnyView(MainView())
        case .Sheet: return AnyView(SheetView())
        case .Present: return AnyView(PresentView())
        }
    }
}
