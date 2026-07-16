//
//  ReadAuth.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import AuthDomain
import UserApplication

public struct ReadAuth: Scope {
    public let account: any AccountQueries
    public let session: any SessionQueries

    public init(
        account: any AccountQueries,
        session: any SessionQueries
    ) {
        self.account = account
        self.session = session
    }
}
