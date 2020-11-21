//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import FeatherCore

@_cdecl("createMarkdownModule")
public func createMarkdownModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(MarkdownBuilder()).toOpaque()
}

public final class MarkdownBuilder: ViperBuilder {

    public override func build() -> ViperModule {
        MarkdownModule()
    }
}
