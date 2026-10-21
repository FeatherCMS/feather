//
//  AuthDetail.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthDomain
public import FeatherApplication
public import UserDomain
public import UserModule

public struct AuthDetail: DTO {
    public var user: Identity.Model
    public var session: Session
    public var roles: [String]
    public var permissions: [String]

    public init(
        user: Identity.Model,
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
