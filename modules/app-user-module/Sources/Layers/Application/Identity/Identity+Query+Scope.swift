//
//  Identity.Query.Scope.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import UserModule

extension Identity.Query {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Interface

        public init(identity: any Interface) {
            self.identity = identity
        }
    }
}
