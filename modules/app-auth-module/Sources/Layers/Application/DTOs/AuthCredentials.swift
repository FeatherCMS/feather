//
//  AuthCredentials.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct AuthCredentials: Sendable {
    public var email: String
    public var password: String
    public var isPersistent: Bool

    public init(
        email: String,
        password: String,
        isPersistent: Bool
    ) {
        self.email = email
        self.password = password
        self.isPersistent = isPersistent
    }
}
