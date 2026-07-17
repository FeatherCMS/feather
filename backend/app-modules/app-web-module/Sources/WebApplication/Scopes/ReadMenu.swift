//
//  ReadMenu.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import WebDomain

public struct ReadMenu: Scope {
    public let menu: any MenuQueries

    public init(menu: any MenuQueries) {
        self.menu = menu
    }
}
