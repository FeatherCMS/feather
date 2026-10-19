public import SystemModule
//
//  WriteTagMetadata.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogDomain
public import FeatherModuleKit
public import SystemApplication
public import WebDomain

public struct WriteTagMetadata: Scope {
    public let tag: any TagRepository
    public let metadata: any MetadataRepository
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        tag: any TagRepository,
        metadata: any MetadataRepository,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.tag = tag
        self.metadata = metadata
        self.variable = variable
    }
}
