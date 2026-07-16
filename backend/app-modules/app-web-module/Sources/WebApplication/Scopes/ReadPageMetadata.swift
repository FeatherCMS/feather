//
//  ReadPageMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import WebDomain

public struct ReadPageMetadata: Scope {
    public let page: any PageQueries
    public let metadata: any MetadataQueries

    public init(
        page: any PageQueries,
        metadata: any MetadataQueries
    ) {
        self.page = page
        self.metadata = metadata
    }
}
