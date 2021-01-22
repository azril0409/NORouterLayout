//
//  NOContentViewProxy.swift
//  NORouterLayout
//
//  Created by Deo on 2021/1/22.
//  Copyright © 2021 NeetOffice. All rights reserved.
//

import SwiftUI

public class NOContentViewProxy{
    private var routerViewModel:NORouterViewModel
    
    internal init(){
        self.routerViewModel = NORouterViewModel(contentView: EmptyView(), delegate: nil, estimateBarHeight: false)
    }
    
    internal func updateRouterViewModel(_ routerViewModel:NORouterViewModel){
        self.routerViewModel = routerViewModel
    }
    
    public func getRouterViewModel() -> NORouterViewModel{
        self.routerViewModel
    }
}
