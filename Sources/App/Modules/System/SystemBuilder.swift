//
//  SystemBuilder.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import Foundation
import ViperKit

@_cdecl("createSystemModule")
public func createSystemModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(SystemBuilder()).toOpaque()
}

public final class SystemBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        SystemModule()
    }
}
