//
//  GetPublicSettings.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import WebDomain

public struct GetPublicSettings {
    let query: any QueryExecutor<WriteSettings>

    public init(
        query: any QueryExecutor<WriteSettings>
    ) {
        self.query = query
    }

    public func execute() async throws -> SettingsDetail {
        try await query.run { scope in
            try await scope.settings.get().asDetail
        }
    }
}
