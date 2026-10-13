//
//  GetPublicRuleBySource.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherContracts

public struct GetPublicRuleBySource {
    public enum Error: UseCaseError {
        case notFound
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
                throw Error.notFound
            }
            return .init(
                source: rule.source,
                destination: rule.destination,
                statusCode: rule.statusCode
            )
        }
    }
}
