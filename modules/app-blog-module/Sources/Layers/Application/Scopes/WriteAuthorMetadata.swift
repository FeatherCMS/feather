public import SystemModule
//
//  WriteAuthorMetadata.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogDomain
public import FeatherModuleKit
public import SystemApplication
public import WebDomain

public struct WriteAuthorMetadata: Scope {
    public let author: any AuthorRepository
    public let metadata: any MetadataRepository
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        author: any AuthorRepository,
        metadata: any MetadataRepository,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.author = author
        self.metadata = metadata
        self.variable = variable
    }
}
