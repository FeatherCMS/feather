//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import Foundation
import ViperKit

@_cdecl("createFrontendModule")
public func createFrontendModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(FrontendBuilder()).toOpaque()
}

public final class FrontendBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        FrontendModule()
    }
}
