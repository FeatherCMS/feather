//
//  WriteAuth.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import AuthDomain
import UserDomain

// TODO: no need for magic link custom scope for sign in
public struct WriteAuth: Scope {
    public let account: any AccountRepository
    public let session: any SessionRepository
    public let magicLink: any MagicLinkRepository

    public init(
        account: any AccountRepository,
        session: any SessionRepository,
        magicLink: any MagicLinkRepository
    ) {
        self.account = account
        self.session = session
        self.magicLink = magicLink
    }
}
