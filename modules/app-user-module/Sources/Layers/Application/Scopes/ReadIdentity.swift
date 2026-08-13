//
//  ReadIdentity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import UserDomain

public struct ReadIdentity: Scope {
    public let identity: any IdentityQueries

    public init(identity: any IdentityQueries) {
        self.identity = identity
    }
}
