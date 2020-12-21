//
//  RouterType.swift
//  NORouterLayout
//
//  Created by Deo on 2020/10/14.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public protocol RouterType{
    func onCreateView(storage:NOEnvironmentObjectStorage) -> AnyView
}
