//
//  ReadMenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherContracts

public struct ReadMenuItem: Scope {
    public let menuItem: any MenuItemQueries

    public init(menuItem: any MenuItemQueries) {
        self.menuItem = menuItem
    }
}
