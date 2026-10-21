//
//  ReadAuth.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import UserModule

public struct ReadAuth: Scope {
    public let authorization: any Identity.Authorization.Query.Interface
    public let session: any SessionQueries

    public init(
        authorization: any Identity.Authorization.Query.Interface,
        session: any SessionQueries
    ) {
        self.authorization = authorization
        self.session = session
    }
}
