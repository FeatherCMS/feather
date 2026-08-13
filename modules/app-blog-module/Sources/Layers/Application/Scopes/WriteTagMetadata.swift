//
//  WriteTagMetadata.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import SystemApplication
import WebDomain

public struct WriteTagMetadata: Scope {
    public let tag: any TagRepository
    public let metadata: any MetadataRepository
    public let variable: any VariableQueries

    public init(
        tag: any TagRepository,
        metadata: any MetadataRepository,
        variable: any VariableQueries
    ) {
        self.tag = tag
        self.metadata = metadata
        self.variable = variable
    }
}
