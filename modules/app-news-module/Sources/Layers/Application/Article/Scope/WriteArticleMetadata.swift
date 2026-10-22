public import FeatherModuleKit
public import NewsDomain
public import NewsModule
public import SystemApplication
public import SystemModule
public import WebDomain
public import WebModule

//
//  WriteArticleMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct WriteArticleMetadata: Scope {
    public let article: any Article.Repository.Interface
    public let metadata: any WebModule.Metadata.Repository.Interface
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        article: any Article.Repository.Interface,
        metadata: any WebModule.Metadata.Repository.Interface,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.article = article
        self.metadata = metadata
        self.variable = variable
    }
}
