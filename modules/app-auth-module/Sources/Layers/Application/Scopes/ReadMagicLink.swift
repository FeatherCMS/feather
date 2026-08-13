//
//  ReadMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts

public struct ReadMagicLink: Scope {
    public let magicLink: any MagicLinkQueries

    public init(
        magicLink: any MagicLinkQueries
    ) {
        self.magicLink = magicLink
    }
}
