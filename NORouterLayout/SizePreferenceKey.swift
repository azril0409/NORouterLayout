//
//  SizePreferenceKey.swift
//  NORouterLayout
//
//  Created by Deo on 2020/11/13.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

class SizePreferenceKey:PreferenceKey{
    typealias Value = CGSize
    static var defaultValue: CGSize = CGSize(width: 0,height: 0)
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
