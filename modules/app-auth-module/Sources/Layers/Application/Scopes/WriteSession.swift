//
//  WriteSession.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts

public struct WriteSession: Scope {
    public let session: any SessionRepository

    public init(session: any SessionRepository) {
        self.session = session
    }
}
