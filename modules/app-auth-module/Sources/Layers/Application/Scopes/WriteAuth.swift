//
//  WriteAuth.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthDomain
public import FeatherModuleKit
public import UserDomain
public import UserModule

// TODO: no need for magic link custom scope for sign in
public struct WriteAuth: Scope {
    public let identity: any Identity.Repository.Interface
    public let authorization: any Identity.Authorization.Query.Interface
    public let credential: any CredentialRepository
    public let authEmail: any AuthEmailRepository
    public let session: any SessionRepository
    public let magicLink: any MagicLinkRepository

    public init(
        identity: any Identity.Repository.Interface,
        authorization: any Identity.Authorization.Query.Interface,
        credential: any CredentialRepository,
        authEmail: any AuthEmailRepository,
        session: any SessionRepository,
        magicLink: any MagicLinkRepository
    ) {
        self.identity = identity
        self.authorization = authorization
        self.credential = credential
        self.authEmail = authEmail
        self.session = session
        self.magicLink = magicLink
    }
}
