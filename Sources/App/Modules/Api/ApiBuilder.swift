//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import Foundation
import ViperKit

@_cdecl("createApiModule")
public func createApiModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(ApiBuilder()).toOpaque()
}

public final class ApiBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        ApiModule()
    }
}
