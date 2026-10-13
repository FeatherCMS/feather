//
//  WritePostMetadata.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogDomain
public import FeatherContracts
public import SystemApplication
public import WebDomain

public struct WritePostMetadata: Scope {
    public let post: any PostRepository
    public let metadata: any MetadataRepository
    public let variable: any VariableQueries

    public init(
        post: any PostRepository,
        metadata: any MetadataRepository,
        variable: any VariableQueries
    ) {
        self.post = post
        self.metadata = metadata
        self.variable = variable
    }
}
