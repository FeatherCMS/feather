//
//  WriteMenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import WebDomain

public struct WriteMenuItem: Scope {
    public let menuItem: any MenuItemRepository

    public init(menuItem: any MenuItemRepository) {
        self.menuItem = menuItem
    }
}
