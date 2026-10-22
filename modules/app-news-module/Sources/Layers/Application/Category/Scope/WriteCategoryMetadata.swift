public import FeatherModuleKit
public import NewsDomain
public import SystemApplication
public import SystemModule
public import WebDomain

//
//  WriteCategoryMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct WriteCategoryMetadata: Scope {
    public let category: any CategoryRepository
    public let metadata: any MetadataRepository
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        category: any CategoryRepository,
        metadata: any MetadataRepository,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.category = category
        self.metadata = metadata
        self.variable = variable
    }
}
