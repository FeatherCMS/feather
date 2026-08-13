//
//  WriteMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import WebDomain

public struct WriteMetadata: Scope {
    public let metadata: any MetadataRepository

    public init(metadata: any MetadataRepository) {
        self.metadata = metadata
    }
}
