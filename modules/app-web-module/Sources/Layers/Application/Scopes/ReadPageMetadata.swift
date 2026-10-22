//
//  ReadPageMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebDomain

public struct ReadPageMetadata: Scope {
    public let page: any Page.Query.Interface
    public let metadata: any Metadata.Query.Interface

    public init(
        page: any Page.Query.Interface,
        metadata: any Metadata.Query.Interface
    ) {
        self.page = page
        self.metadata = metadata
    }
}
