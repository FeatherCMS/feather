//
//  ReadAccount.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import UserDomain

public struct ReadAccount: Scope {
    public let account: any AccountQueries

    public init(account: any AccountQueries) {
        self.account = account
    }
}
