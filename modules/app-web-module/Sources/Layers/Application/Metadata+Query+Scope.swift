//
//  Metadata.Query.Scope.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebDomain

extension Metadata.Query {
    public struct Scope: FeatherModuleKit.Scope {
        public let metadata: any Interface

        public init(metadata: any Interface) {
            self.metadata = metadata
        }
    }
}
