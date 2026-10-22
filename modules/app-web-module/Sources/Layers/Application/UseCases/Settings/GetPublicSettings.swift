//
//  GetPublicSettings.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
public import WebDomain

public struct GetPublicSettings {
    let query: any QueryExecutor<Settings.Repository.Scope>

    public init(
        query: any QueryExecutor<Settings.Repository.Scope>
    ) {
        self.query = query
    }

    public func execute() async throws -> SettingsDetail {
        try await query.run { scope in
            try await scope.settings.get().asDetail
        }
    }
}
