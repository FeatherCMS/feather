//
//  WriteMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import AuthDomain

public struct WriteMagicLink: Scope {
    public let magicLink: any MagicLinkRepository

    public init(magicLink: any MagicLinkRepository) {
        self.magicLink = magicLink
    }
}
