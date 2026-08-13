//
//  ReadAuth.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import UserApplication

public struct ReadAuth: Scope {
    public let identity: any IdentityQueries
    public let session: any SessionQueries

    public init(
        identity: any IdentityQueries,
        session: any SessionQueries
    ) {
        self.identity = identity
        self.session = session
    }
}
