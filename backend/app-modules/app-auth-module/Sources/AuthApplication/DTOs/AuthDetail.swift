//
//  AuthDetail.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import AuthDomain
import UserDomain

public struct AuthDetail: DTO {
    public var user: Account
    public var session: Session
    public var roles: [String]
    public var permissions: [String]

    public init(
        user: Account,
        session: Session,
        roles: [String],
        permissions: [String]
    ) {
        self.user = user
        self.session = session
        self.roles = roles
        self.permissions = permissions
    }
}
