//
//  WriteAccount.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import UserDomain

public struct WriteAccount: Scope {
    public let account: any AccountRepository
    public let role: any RoleRepository

    public init(
        account: any AccountRepository,
        role: any RoleRepository
    ) {
        self.account = account
        self.role = role
    }
}
