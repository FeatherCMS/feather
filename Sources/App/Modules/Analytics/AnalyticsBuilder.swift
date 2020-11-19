//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

import FeatherCore

@_cdecl("createAnalyticsModule")
public func createAnalyticsModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(AnalyticsBuilder()).toOpaque()
}

public final class AnalyticsBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        AnalyticsModule()
    }
}
