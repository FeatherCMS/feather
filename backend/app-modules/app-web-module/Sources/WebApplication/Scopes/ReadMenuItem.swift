//
//  ReadMenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import WebDomain

public struct ReadMenuItem: Scope {
    public let menuItem: any MenuItemQueries

    public init(menuItem: any MenuItemQueries) {
        self.menuItem = menuItem
    }
}
