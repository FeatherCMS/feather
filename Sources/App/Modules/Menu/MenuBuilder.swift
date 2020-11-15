//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Foundation
import ViperKit

@_cdecl("createMenuModule")
public func createMenuModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(MenuBuilder()).toOpaque()
}

public final class MenuBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        MenuModule()
    }
}
