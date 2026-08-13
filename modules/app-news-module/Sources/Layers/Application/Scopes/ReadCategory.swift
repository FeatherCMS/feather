//
//  ReadCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import NewsDomain

public struct ReadCategory: Scope {
    public let category: any CategoryQueries

    public init(category: any CategoryQueries) {
        self.category = category
    }
}
