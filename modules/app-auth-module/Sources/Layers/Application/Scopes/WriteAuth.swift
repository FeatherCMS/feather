//
//  WriteAuth.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import UserDomain

// TODO: no need for magic link custom scope for sign in
public struct WriteAuth: Scope {
    public let identity: any IdentityRepository
    public let credential: any CredentialRepository
    public let session: any SessionRepository
    public let magicLink: any MagicLinkRepository

    public init(
        identity: any IdentityRepository,
        credential: any CredentialRepository,
        session: any SessionRepository,
        magicLink: any MagicLinkRepository
    ) {
        self.identity = identity
        self.credential = credential
        self.session = session
        self.magicLink = magicLink
    }
}
