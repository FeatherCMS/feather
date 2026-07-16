//
//  ReadPage.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import WebDomain

public struct ReadPage: Scope {
    public let page: any PageQueries

    public init(page: any PageQueries) {
        self.page = page
    }
}
