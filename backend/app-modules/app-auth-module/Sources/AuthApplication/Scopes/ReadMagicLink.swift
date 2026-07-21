//
//  ReadMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import AuthDomain

public struct ReadMagicLink: Scope {
    public let magicLink: any MagicLinkQueries

    public init(
        magicLink: any MagicLinkQueries
    ) {
        self.magicLink = magicLink
    }
}
