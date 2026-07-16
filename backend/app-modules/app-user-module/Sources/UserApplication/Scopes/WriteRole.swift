//
//  WriteRole.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import UserDomain

public struct WriteRole: Scope {
    public let role: any RoleRepository

    public init(role: any RoleRepository) {
        self.role = role
    }
}
