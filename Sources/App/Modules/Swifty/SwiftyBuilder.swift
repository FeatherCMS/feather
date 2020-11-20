//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import Foundation
import ViperKit

@_cdecl("createSwiftyModule")
public func createSwiftyModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(SwiftyBuilder()).toOpaque()
}

public final class SwiftyBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        SwiftyModule()
    }
}
