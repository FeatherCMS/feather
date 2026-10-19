//
//  WriteMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthDomain
public import FeatherModuleKit

public struct WriteMagicLink: Scope {
    public let magicLink: any MagicLinkRepository

    public init(magicLink: any MagicLinkRepository) {
        self.magicLink = magicLink
    }
}
