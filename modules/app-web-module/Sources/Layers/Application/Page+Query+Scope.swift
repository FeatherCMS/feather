//
//  Page.Query.Scope.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebDomain

extension Page.Query {
    public struct Scope: FeatherModuleKit.Scope {
        public let page: any Interface

        public init(page: any Interface) {
            self.page = page
        }
    }
}
