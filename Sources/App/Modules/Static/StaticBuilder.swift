//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import Foundation
import ViperKit

@_cdecl("createStaticModule")
public func createStaticModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(StaticBuilder()).toOpaque()
}

public final class StaticBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        StaticModule()
    }
}
