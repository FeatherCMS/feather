//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

import Foundation
import ViperKit

@_cdecl("createSiteModule")
public func createSiteModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(SiteBuilder()).toOpaque()
}

public final class SiteBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        SiteModule()
    }
}
