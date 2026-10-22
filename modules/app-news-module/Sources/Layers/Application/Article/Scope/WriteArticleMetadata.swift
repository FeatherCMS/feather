public import FeatherModuleKit
public import NewsModule
public import NewsDomain
public import SystemApplication
public import SystemModule
public import WebDomain

//
//  WriteArticleMetadata.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct WriteArticleMetadata: Scope {
    public let article: any Article.Repository.Interface
    public let metadata: any Metadata.Repository.Interface
    public let variable: any SystemModule.Variable.Lookup.Interface

    public init(
        article: any Article.Repository.Interface,
        metadata: any Metadata.Repository.Interface,
        variable: any SystemModule.Variable.Lookup.Interface
    ) {
        self.article = article
        self.metadata = metadata
        self.variable = variable
    }
}
