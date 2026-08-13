//
//  ResolveWebRoute.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation

public struct ResolveWebRoute {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadMetadata>

    public init(
        query: any QueryExecutor<ReadMetadata>
    ) {
        self.query = query
    }

    public func execute(
        slug: String
    ) async throws -> WebRouteDetail {
        let now = Date()
        return try await query.run { scope in
            guard let metadata = try await scope.metadata.resolve(slug: slug),
                metadata.isDirectlyAccessible(at: now)
            else {
                throw Error(message: "Route not found")
            }
            let referenceType = metadata.referenceType
            let referenceID = metadata.referenceID

            return .init(
                referenceType: referenceType,
                referenceID: referenceID,
                slug: metadata.slug,
                template: metadata.template
            )
        }
    }
}
