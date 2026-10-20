//
//  Identity.Repository.Scope.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import UserDomain
public import UserModule

extension Identity.Repository {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Interface
        public let role: any Role.Repository.Interface

        public init(
            identity: any Interface,
            role: any Role.Repository.Interface
        ) {
            self.identity = identity
            self.role = role
        }
    }
}
