//
//  WriteMenu.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebDomain

public struct WriteMenu: Scope {
    public let menu: any MenuRepository

    public init(menu: any MenuRepository) {
        self.menu = menu
    }
}
