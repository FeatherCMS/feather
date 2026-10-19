//
//  ReadSession.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit

public struct ReadSession: Scope {
    public let session: any SessionQueries

    public init(
        session: any SessionQueries
    ) {
        self.session = session
    }
}
