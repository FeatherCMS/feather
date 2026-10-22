//
//  WriteCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import NewsDomain
public import NewsModule

public struct WriteCategory: Scope {
    public let category: any Category.Repository.Interface

    public init(category: any Category.Repository.Interface) {
        self.category = category
    }
}
