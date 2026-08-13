//
//  ReadSession.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts

public struct ReadSession: Scope {
    public let session: any SessionQueries

    public init(
        session: any SessionQueries
    ) {
        self.session = session
    }
}
