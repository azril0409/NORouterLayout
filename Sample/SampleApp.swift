//
//  SampleApp.swift
//  Sample
//
//  Created by Deo on 2020/10/14.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import NORouterLayout

@main
struct SampleApp: App {
    var body: some Scene {
        WindowGroup {
            NOContentView().environmentObject(NORouterViewModel(Router.Main, "Main"))
        }
    }
}
