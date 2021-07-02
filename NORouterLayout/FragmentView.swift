//
//  FragmentView.swift
//  NORouterLayout
//
//  Created by Deo on 2021/7/2.
//  Copyright © 2021 NeetOffice. All rights reserved.
//

import SwiftUI

public struct FragmentView: View {
    @ObservedObject private var fragmentViewMode:FragmentViewMode
    
    public init(_ fragmentViewMode:FragmentViewMode){
        self.fragmentViewMode = fragmentViewMode
    }
    
    public var body: some View {
        ZStack{
            if !self.fragmentViewMode.isAnimationRunning {
                self.fragmentViewMode.fragmentView?.transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FragmentView_Previews: PreviewProvider {
    static var previews: some View {
        let fragmentViewMode = FragmentViewMode(content: Text("Hello, World!"))
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            fragmentViewMode.add(Color.pink.transition(.move(edge: .bottom)))
        }
        return  FragmentView(fragmentViewMode)
    }
}
