//
//  NOContentViewReader.swift
//  NORouterLayout
//
//  Created by Deo on 2021/1/22.
//  Copyright © 2021 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NOContentViewReader: View {
    private let contentViewProxy = NOContentViewProxy()
    private let content:NOContentView
    
    public init(@ViewBuilder content:(NOContentViewProxy)->NOContentView) {
        self.content = content(contentViewProxy)
        contentViewProxy.updateRouterViewModel(self.content.routerViewModel)
    }
    
    public var body: some View {
        SceneView().edgesIgnoringSafeArea(content.edge).environmentObject(content.routerViewModel)
    }
}
