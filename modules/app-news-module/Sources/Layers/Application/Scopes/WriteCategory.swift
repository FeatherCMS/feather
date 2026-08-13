//
//  WriteCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import NewsDomain

public struct WriteCategory: Scope {
    public let category: any CategoryRepository

    public init(category: any CategoryRepository) {
        self.category = category
    }
}
