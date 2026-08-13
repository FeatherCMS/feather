//
//  WriteIdentity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import UserDomain

public struct WriteIdentity: Scope {
    public let identity: any IdentityRepository

    public init(
        identity: any IdentityRepository
    ) {
        self.identity = identity
    }
}
