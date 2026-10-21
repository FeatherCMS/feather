//
//  ReadAuth.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import UserApplication
public import UserModule

public struct ReadAuth: Scope {
    public let identity: any Identity.Authorization.Query.Interface
    public let session: any SessionQueries

    public init(
        identity: any Identity.Authorization.Query.Interface,
        session: any SessionQueries
    ) {
        self.identity = identity
        self.session = session
    }
}
