//
//  WritePage.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import WebDomain

public struct WritePage: Scope {
    public let page: any PageRepository

    public init(page: any PageRepository) {
        self.page = page
    }
}
