//
//  ReadMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherContracts

public struct ReadMetadata: Scope {
    public let metadata: any MetadataQueries

    public init(metadata: any MetadataQueries) {
        self.metadata = metadata
    }
}
