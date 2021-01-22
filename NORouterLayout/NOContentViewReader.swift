//
//  NOContentViewReader.swift
//  NORouterLayout
//
//  Created by Deo on 2021/1/22.
//  Copyright © 2021 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NOContentViewReader: View {
    private let content:NOContentView
    
    init(@ViewBuilder content:(NOContentViewProxy)->NOContentView) {
        let contentViewProxy = NOContentViewProxy()
        self.content = content(contentViewProxy)
        let routerViewModel = self.content.routerViewModel
        contentViewProxy.updateRouterViewModel(routerViewModel)
    }
    
    public var body: some View {
        SceneView().edgesIgnoringSafeArea(content.edge).environmentObject(content.routerViewModel)
    }
}

struct NOContentViewReader_Previews: PreviewProvider {
    static var previews: some View {
        NOContentViewReader{_ in
            NOContentView(Text("Hello World!!"))
        }
    }
}
