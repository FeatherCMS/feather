//
//  GetPublicRuleBySource.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct GetPublicRuleBySource {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadRule>

    public init(
        query: any QueryExecutor<ReadRule>
    ) {
        self.query = query
    }

    public func execute(
        source: String
    ) async throws -> PublicRedirectRule {
        try await query.run { scope in
            guard let rule = try await scope.rule.find(source: source) else {
                throw Error(message: "Redirect rule not found")
            }
            return .init(
                source: rule.source,
                destination: rule.destination,
                statusCode: rule.statusCode
            )
        }
    }
}
