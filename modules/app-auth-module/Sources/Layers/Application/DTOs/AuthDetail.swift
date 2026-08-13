//
//  AuthDetail.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import UserDomain

public struct AuthDetail: DTO {
    public var user: Identity
    public var session: Session
    public var roles: [String]
    public var permissions: [String]

    public init(
        user: Identity,
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
