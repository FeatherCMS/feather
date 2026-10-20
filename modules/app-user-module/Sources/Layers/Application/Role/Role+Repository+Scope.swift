//
//  Role.Repository.Scope.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import UserDomain
public import UserModule

extension Role.Repository {
    public struct Scope: FeatherModuleKit.Scope {
        public let role: any Interface

        public init(role: any Interface) {
            self.role = role
        }
    }
}
